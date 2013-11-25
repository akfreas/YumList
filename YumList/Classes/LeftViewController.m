#import "LeftViewController.h"
#import "AddYumSourceCell.h"

@interface LeftViewController ()

@end

#define AddSourceSection 0

@implementation LeftViewController {
    CGFloat addSourceCellHeight;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        addSourceCellHeight = 44;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[AddYumSourceCell class] forCellReuseIdentifier:@"SettingCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Generic"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == AddSourceSection) {
        return 1;
    } else {
        return 5;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == AddSourceSection) {
        return NO;
    }
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == AddSourceSection) {
        return addSourceCellHeight;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    if (indexPath.section == AddSourceSection) {
        static NSString *CellIdentifier = @"SettingCell";
        AddYumSourceCell *addSourceCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // Configure the cell...
        addSourceCell.addSourceButtonTapped = ^(CGFloat newSize){
            addSourceCellHeight = newSize;
            [self.tableView beginUpdates];
        };
        addSourceCell.expandAnimationCompleted = ^{
            [self.tableView endUpdates];
        };
        cell = addSourceCell;
    } else {
        UITableViewCell *genericCell = [tableView dequeueReusableCellWithIdentifier:@"Generic" forIndexPath:indexPath];
        genericCell.textLabel.text = @"Waterbugz.";
        cell = genericCell;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
