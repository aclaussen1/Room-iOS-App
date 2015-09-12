//
//  VoteTableViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "VoteTableViewController.h"
#import "VoteTableViewCell.h"

@interface VoteTableViewController ()
@property NSArray *songTitles;
@property NSArray *songArtists;
@property PFQuery *query;
@property PFObject *party;
@property NSMutableArray *votes;

@end

@implementation VoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.query = [PFQuery queryWithClassName:@"Party"];
    NSLog(@"My partyobjectId is %@", self.partyObjectID);
    [self.query whereKey:@"objectId" equalTo:self.partyObjectID];
    self.party = [self.query getFirstObject];
    
    self.votes = [NSMutableArray arrayWithArray:self.party[@"votes"] ];
    self.songTitles = self.party[@"Songs"];
    self.songArtists = self.party[@"SongArtists"];
    for (int x = 0; x < self.songTitles.count; x++)
    {
        NSLog(@"%@ dick", [self.songTitles objectAtIndex:x]);
    }

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

    return [self.songTitles count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    VoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SongPick" forIndexPath:indexPath];
    
    cell.songTitle.text = [self.songTitles objectAtIndex:indexPath.row];
    cell.songArtist.text = [self.songArtists objectAtIndex:indexPath.row];
 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *songNumber = [NSNumber numberWithInt:indexPath.row];
    [self.votes addObject:songNumber];
    NSArray *newVotes = [self.votes copy];
    self.party[@"votes"] = newVotes;
    [self.party saveInBackground];
    
    
    
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
