//
//  JoinerTableViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "JoinerTableViewController.h"
#import "Parse/Parse.h"
#import "JoinerOptionsUITableViewCell.h"
@interface JoinerTableViewController ()
@property PFQuery *parseQuery;
@property NSArray *parties;
@end

@implementation JoinerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parseQuery = [PFQuery queryWithClassName:@"Party"];
    self.parties = [self.parseQuery findObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parties.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   JoinerOptionsUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"joinOption" forIndexPath:indexPath];
    
    cell.nameOfGroup.text = [self.parties objectAtIndex:indexPath.row][@"nameOfParty"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFFile *file = [[self.parties objectAtIndex:indexPath.row] objectForKey:@"imageOfParty"];
        UIImage *image = [UIImage imageWithData:[file getData]];
        // Use main thread to update the view. View changes are always handled through main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // Refresh image view here
            cell.imageOfGroup.image = image;
            cell.imageOfGroup.layer.cornerRadius = cell.imageOfGroup.frame.size.width / 2 ;
            cell.imageOfGroup.clipsToBounds = YES;
            [cell setNeedsLayout];
        });
    });
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
