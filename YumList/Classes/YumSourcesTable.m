#import "YumSourcesTable.h"
#import "YumSource.h"
#import "NSFetchedResultsControllerFactory.h"



@implementation YumSourcesTable {
    NSFetchedResultsController *fetchController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Generic"];
        [self setupFetchController];
    }
    return self;
}



-(void)setupFetchController {
    
    fetchController = [NSFetchedResultsControllerFactory fetchControllerForYumSources];
    fetchController.delegate = self;
    NSError *err = nil;
    [fetchController performFetch:&err];
    if (err != nil) {
        NSLog(@"Error performing fetch in %@", self.class);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString * headerString = NSLocalizedString(@"Recipe Sources", @"Recipe sources header view in left view.");
    return headerString;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [[[fetchController sections] objectAtIndex: section] numberOfObjects];
    return rows;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *genericCell = [tableView dequeueReusableCellWithIdentifier:@"Generic" forIndexPath:indexPath];
    [self configureCell:genericCell atIndexPath:indexPath];
    return genericCell;
}


#pragma mark NSFetchedResultsController Delegate Methods


-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate: {
            
            UITableViewCell *cell = [self tableView:self cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
        }
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        default:
            break;
    }
    
}


#pragma mark Helpers

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YumSource *source = [fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = source.name;
}


@end
