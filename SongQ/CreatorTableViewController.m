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
#import "infomationTableViewCell.h"
#import "WhatPeopleWantToHearTableViewCell.h"
@interface CreatorTableViewController ()
@property MPMusicPlayerController *managedPlayer;
@property NSUInteger nextSongToPlay;

@end

@implementation CreatorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 451;
    }
    else if (indexPath.row == 1) {
        return 50;
    }
    //what people want to hear table view cell
    else return 149;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   [self.partyUploaded fetch];
    if([[self.partyUploaded objectForKey:@"votes"] count] ==  0){
        return 2;
    } else {
        return 3;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
    creatorMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    //same music player as the cell, but this can be accessed outside this method
        if (!self.managedPlayer) {
            NSLog(@"HEY BITCHES!!!!!!!!!!");
    cell.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    self.managedPlayer = cell.musicPlayer;
    [cell.musicPlayer setQueueWithItemCollection: self.mediaItemCollection];
    [cell.musicPlayer play];
        
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
    [notificationCenter addObserver: self
                            selector: @selector (handle_NowPlayingItemChanged:)
                                name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                object: cell.musicPlayer];
        
        [cell.musicPlayer beginGeneratingPlaybackNotifications];
        }
    
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
    } else if (indexPath.row == 1) {
        
       infomationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([[self.partyUploaded objectForKey:@"votes"] count] ==  0){
            cell.information.text = @"No votes have been cast yet.";
        } else {
            cell.information.text = @"Here's what people want to hear next:";
        }
        
        return cell;
    }
    //shouldn't return null
    else {
        
        //[self.musicPlayer setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:[songsQuery items]]];
        self.mediaItemCollection = [MPMediaItemCollection collectionWithItems:[[MPMediaQuery songsQuery] items]];
        WhatPeopleWantToHearTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"whatPeopleWantToHear" forIndexPath:indexPath];
        
        //http://stackoverflow.com/questions/12226776/finding-most-repeated-object-in-array
        
        [self.partyUploaded fetch];
        
        //create count set from array
        NSCountedSet *setOfObjects = [[NSCountedSet alloc] initWithArray:[self.partyUploaded objectForKey:@"votes"]];
        
        //Declaration of objects
        NSNumber *mostOccurringObject;
        NSUInteger highestCount = 0;
        
        
        //Iterate in set to find highest count for a object
        for (NSNumber *intObject in setOfObjects)
        {
            NSUInteger tempCount = [setOfObjects countForObject:intObject];
            if (tempCount > highestCount)
            {
                    highestCount = tempCount;
                    mostOccurringObject = intObject;
            
            }
        }
        
        NSLog(@"most occuring number is %@", mostOccurringObject);
        NSInteger mostOccuringObjectNSInteger = [mostOccurringObject integerValue];
        self.nextSongToPlay = mostOccuringObjectNSInteger;
        NSLog(@"we are dealing with %@", [self.mediaItemCollection.items objectAtIndex:mostOccuringObjectNSInteger]);
        MPMediaItemArtwork *artwork = [[self.mediaItemCollection.items objectAtIndex:mostOccuringObjectNSInteger] valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork != nil) {
            NSLog(@"artwork not nil");
            cell.albumArt.image = [artwork imageWithSize:CGSizeMake(128, 129)];
        } else {
            NSLog(@"artwork nil");
        }
        
        cell.title.text = [[self.mediaItemCollection.items objectAtIndex:mostOccuringObjectNSInteger] title];
        cell.artist.text = [[self.mediaItemCollection.items objectAtIndex:mostOccuringObjectNSInteger] artist];
        cell.album.text = [[self.mediaItemCollection.items objectAtIndex:mostOccuringObjectNSInteger] albumTitle];
        cell.votes.text = [NSString stringWithFormat:@"Votes: %ld", (long)highestCount ];
        return cell;
    };
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
    
    if (self.nextSongToPlay != -1) {
        NSUInteger copy = self.nextSongToPlay;
        self.nextSongToPlay = -1;
        [self.managedPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
        NSLog(@"%zd is the number of next song to play", self.nextSongToPlay);
        self.managedPlayer.nowPlayingItem = [[[MPMediaQuery songsQuery] items] objectAtIndex:copy];
        [self reloadData];
        
    } else {
        [self reloadData];
    }
}




@end
