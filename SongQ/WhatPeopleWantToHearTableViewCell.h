//
//  WhatPeopleWantToHearTableViewCell.h
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatPeopleWantToHearTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *album;

@property (weak, nonatomic) IBOutlet UILabel *votes;
@end
