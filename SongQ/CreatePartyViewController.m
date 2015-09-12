//
//  CreatePartyViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/11/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "CreatePartyViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CreatePartyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;

@property (weak, nonatomic) IBOutlet UIButton *playorpause;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet MPVolumeView *volumeView;
@property MPMusicPlayerController *musicPlayer;
@end

@implementation CreatePartyViewController
- (IBAction)volumeChanged:(id)sender {
}
- (IBAction)showMediaPicker:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    NSLog(@"%lu count", (unsigned long)mediaItemCollection.items.count);
    if (mediaItemCollection.items.count == 0)
    {
        NSLog(@"mediaItemColllection no items");
    }
    else
    {

        for (int x = 0; x < mediaItemCollection.items.count; x++)
        {
            MPMediaItem *item = [mediaItemCollection.items objectAtIndex:x];
             NSLog(@"%@",item.title);
             }
        }

    if (mediaItemCollection) {
        
        [_musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [_musicPlayer play];
    }
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissModalViewControllerAnimated: YES];
}




- (IBAction)back:(id)sender {
     [_musicPlayer skipToPreviousItem];
}
- (IBAction)playpauseaction:(id)sender {
    NSLog(@"hi");
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [_musicPlayer pause];
        
    } else {
        [_musicPlayer play];
        
    }
}
- (IBAction)next:(id)sender {
    [_musicPlayer skipToNextItem];
}

- (void) registerMediaPlayerNotifcations {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: _musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: _musicPlayer];
    
    /*[notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: _musicPlayer];
    */
    [_musicPlayer beginGeneratingPlaybackNotifications];
    
    
}
- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [_musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    [_artworkImage setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        _titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        _titleLabel.text = @"Title: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        _artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        _artistLabel.text = @"Artist: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        _albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        _albumLabel.text = @"Album: Unknown album";
    }
    
}
/*
- (void) handle_VolumeChanged: (id) notification
{
    [_volumeView setValue:[_musicPlayer volume]];
}
 */

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [_musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        //[playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        //[playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        
        //[playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [_musicPlayer stop];
        
    }
    
}

- (void)viewDidLoad {
    [MPVolumeView alloc];
    [super viewDidLoad];
    
    /*
    PFObject *testObject = [PFObject objectWithClassName:@"Party"];
    testObject[@"test"] = @"bar";
    [testObject saveInBackground];
     */
    _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    //[_volumeSlider setValue:[_musicPlayer volume]];
    
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        _playorpause.titleLabel.text = @"Pause";
        //[playPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
    } else {
         _playorpause.titleLabel.text = @"Play";
        //[playPauseButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    }
    /*
    MPMusicPlayerController* appMusicPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
    
    [appMusicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [appMusicPlayer setRepeatMode: MPMusicRepeatModeNone];
    */
    // assign a playback queue containing all media items on the device
    //[myPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
    
    // start playing from the beginning of the queue
    //[myPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
