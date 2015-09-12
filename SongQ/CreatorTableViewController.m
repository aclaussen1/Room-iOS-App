//
//  CreatorTableViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "CreatorTableViewController.h"
#import "creatorMainTableViewCell.h"
#import "Parse/Parse.h"
@interface CreatorTableViewController ()

@end

@implementation CreatorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)homeButton:(id)sender {
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    creatorMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [cell.musicPlayer setQueueWithItemCollection: self.mediaItemCollection];
    [cell.musicPlayer play];
    
    cell.songTitle.text = cell.musicPlayer.nowPlayingItem.title;
    cell.songArtist.text = cell.musicPlayer.nowPlayingItem.artist;
    cell.songAlbum.text = cell.musicPlayer.nowPlayingItem.albumTitle;
    MPMediaItemArtwork *artwork = [cell.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    
    PFFile *imageFile = [self.partyUploaded objectForKey:@"imageOfParty"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.groupImage.image= image;
            //to create circlular image
            cell.groupImage.layer.cornerRadius = cell.groupImage.frame.size.width / 2;
            cell.groupImage.clipsToBounds = YES;
        }
    }];
    cell.groupName.text = [self.partyUploaded objectForKey:@"nameOfParty"];
    //doesn't allow user to select this cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    /*
    PFObject *obj = [[PFObject alloc] initWithClassName:@"Party"];
    UIImage *chosenImage = [artwork imageWithSize:c];
    NSData *data=UIImagePNGRepresentation(chosenImage);
    PFFile *fileToSubmit = [PFFile fileWithName:@"image.png" data:data];
    obj[@"test"] = @"hi";
    //obj[@"imageOfParty"] = fileToSubmit;
    [obj saveInBackground];
     */
    if (artwork != nil) {
        NSLog(@"artwork not nil");
        cell.albumPicture.image = [artwork imageWithSize:CGSizeMake(128, 129)];
    } else {
        NSLog(@"artwork nil");
    }
    
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
