#import "ListTableView.h"
#import "NSFetchedResultsControllerFactory.h"
#import "ListItem.h"
#import "ListItemTableViewCell.h"

@interface ListTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ListTableView {
    
    NSFetchedResultsController *fetchController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFetchController];
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
}

-(void)configureCell:(ListItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ListItem *item = [fetchController objectAtIndexPath:indexPath];
    cell.listItem = item;
}

#pragma mark UITableViewDataSource Delegate Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[fetchController sections] objectAtIndex:section] count];
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
