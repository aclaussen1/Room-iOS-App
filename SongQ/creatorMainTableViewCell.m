//
//  creatorMainTableViewCell.m
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "creatorMainTableViewCell.h"


@implementation creatorMainTableViewCell



- (IBAction)play:(id)sender {
    NSLog(@"hi");
    if ([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        
    } else {
        [self.musicPlayer play];
        
    }

}
- (IBAction)forward:(id)sender {
}
- (IBAction)back:(id)sender {
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
