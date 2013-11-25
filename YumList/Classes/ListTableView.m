#import "ListTableView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "ListItemTableViewCell.h"
#import "AddListItemTableViewHeader.h"
#import "TestDataGenerator.h"
#import "PersistenceManager.h"
#import "YumCollector.h"
#import "YumItem.h"
#import "SourceManager.h"

@interface ListTableView () <UITableViewDataSource, UITableViewDelegate>

@end 

@implementation ListTableView {
    
    YumCollector *collector;
    BOOL userDrivenChange;
}

static NSString *identifier = @"ListCellID";


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.autoresizesSubviews = YES;
        self.allowsSelection = NO;
        collector = [YumCollector new];
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin);
        userDrivenChange = NO;
        [self registerClass:[ListItemTableViewCell class] forCellReuseIdentifier:identifier];
        [self setupFetchController];
        [self setupSourceChangedBehavior];
    }
    return self;
}

-(void)setupSourceChangedBehavior {
    
    [SourceManager setYumSourceChangedAction:^(YumSource *source) {
        self.fetchController = [NSFetchedResultsControllerFactory fetchControllerForYumItemsFromSource:source];
        [collector syncYumsForSource:source completion:^(NSArray *newYums) {
            [self.fetchController performFetch:NULL];
            [self reloadData];
        }];
    }];
}

-(void)setupFetchController {
    self.fetchController = [NSFetchedResultsControllerFactory fetchControllerForAllYumItems];
    NSError *controllerError = nil;
    self.fetchController.delegate = self;
    [self.fetchController performFetch:&controllerError];
    if (controllerError != nil) {
        NSLog(@"Error performing fetch on %@ fetch controller. Description: %@", NSStringFromClass(self.class), controllerError.description);
    }
}

#pragma mark UITableView Override Methods

-(void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    userDrivenChange = YES;
    
    NSMutableArray *reorderArray = [[self.fetchController fetchedObjects] mutableCopy];
    ListItem *itemToMove = [self.fetchController objectAtIndexPath:indexPath];
    [reorderArray removeObject:itemToMove];
    [reorderArray insertObject:itemToMove atIndex:newIndexPath.row];
    for (int i=0; i<[reorderArray count]; i++) {
        ListItem *reorderingItem = reorderArray[i];
        reorderingItem.listOrder = [NSNumber numberWithInteger:i];
    }
    [PersistenceManager saveContext:self.fetchController.managedObjectContext];
    userDrivenChange = NO;
}

-(void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ListTableEditing" object:nil userInfo:@{@"editing": [NSNumber numberWithBool:editing]}];
}

#pragma mark NSFetchedResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (userDrivenChange == NO) {
        [self beginUpdates];
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (userDrivenChange == NO) {
        [self endUpdates];
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (anObject != nil && userDrivenChange == NO) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(ListItemTableViewCell *)[self cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeDelete:
                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                break;
            default:
                break;
        }
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark UITableViewDataSource Delegate Methods

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    ListItemTableViewCell *cell = (ListItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.editing = YES;
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    ListItemTableViewCell *cell = (ListItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.editing = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchController sections] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListItemTableViewCell *cell = (ListItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


-(void)configureCell:(ListItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    YumItem *item = [self.fetchController objectAtIndexPath:indexPath];
    cell.yumItem = item;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListItem *deleteItem = [self.fetchController objectAtIndexPath:indexPath];
        [deleteItem delete];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

#pragma mark UITableViewDelegate Delegate Methods





@end
