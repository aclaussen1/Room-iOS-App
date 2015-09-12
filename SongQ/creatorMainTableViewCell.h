//
//  creatorMainTableViewCell.h
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface creatorMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songArtist;
@property (weak, nonatomic) IBOutlet UILabel *songAlbum;
@property (weak, nonatomic) IBOutlet UIView *albumPicture;

@end
