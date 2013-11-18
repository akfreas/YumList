#import "ListTableView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "ListItem.h"
#import "ListItemTableViewCell.h"
#import "AddListItemTableViewHeader.h"

@interface ListTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ListTableView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFetchController];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

-(void)setupFetchController {
    self.fetchController = [NSFetchedResultsControllerFactory fetchControllerForAllListItems];
    
    NSError *controllerError = nil;
    self.fetchController.delegate = self;
    [self.fetchController performFetch:&controllerError];
    if (controllerError != nil) {
        NSLog(@"Error performing fetch on %@ fetch controller. Description: %@", NSStringFromClass(self.class), controllerError.description);
    }
}

-(void)configureCell:(ListItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ListItem *item = [self.fetchController objectAtIndexPath:indexPath];
    cell.listItem = item;
}

#pragma mark NSFetchedResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}


-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (anObject != nil) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(ListItemTableViewCell *)[self cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeDelete:
                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = nil;
    if (section == 0) {
        headerView = [[AddListItemTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSInteger retVal = 0;
    if (section == 0) {
        retVal = 70;
    }
    return retVal;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchController sections] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ListCellID";
    ListItemTableViewCell *cell = (ListItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[ListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListItem *deleteItem = [self.fetchController objectAtIndexPath:indexPath];
        [deleteItem delete];
    }
}

#pragma mark UITableViewDelegate Delegate Methods





@end
