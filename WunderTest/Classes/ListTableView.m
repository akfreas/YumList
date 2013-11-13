#import "ListTableView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "ListItem.h"
#import "ListItemTableViewCell.h"

@interface ListTableView () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@end

@implementation ListTableView {
    
    NSFetchedResultsController *fetchController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFetchController];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

-(void)setupFetchController {
    fetchController = [NSFetchedResultsControllerFactory fetchControllerForAllListItems];
    
    NSError *controllerError = nil;
    [fetchController performFetch:&controllerError];
    if (controllerError != nil) {
        NSLog(@"Error performing fetch on %@ fetch controller. Description: %@", NSStringFromClass(self.class), controllerError.description);
    }
    fetchController.delegate = self;
}

-(void)configureCell:(ListItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ListItem *item = [fetchController objectAtIndexPath:indexPath];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[fetchController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchController sections] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ListCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[ListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:(ListItemTableViewCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate Delegate Methods



@end
