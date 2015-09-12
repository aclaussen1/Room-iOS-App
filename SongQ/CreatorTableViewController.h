//
//  CreatorTableViewController.h
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface CreatorTableViewController : UITableViewController

@property  MPMediaItemCollection * mediaItemCollection;
@property PFObject *partyUploaded;
@end
