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
#import "CNPPopupController.h"
#import "CreatorTableViewController.h"

@interface CreatePartyViewController ()


@property (weak, nonatomic) IBOutlet UIButton *playorpause;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UITextField *nameOfGroup;
@property (weak, nonatomic) IBOutlet UIImageView *partyImage;
@property (nonatomic) BOOL hasPickedAnImage;
@property MPMusicPlayerController *musicPlayer;
@property PFObject *partyToUpload;
@property  NSArray *mutableToNonmutableTitles;
@property  NSArray *mutableToNonmutableArtists;
@property PFFile *imageFile;
@property MPMediaItemCollection * selectedMediaItemCollection;

@end

@implementation CreatePartyViewController


- (IBAction)showMediaPicker:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentModalViewController:mediaPicker animated:YES];
    
}
- (IBAction)createGroup:(id)sender {
    
    
    self.partyToUpload = [PFObject objectWithClassName:@"Party"];
    self.partyToUpload[@"nameOfParty"] = self.nameOfGroup.text;
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    NSMutableArray *songTitles = [[NSMutableArray alloc] init];
    NSMutableArray *songArtists = [[NSMutableArray alloc] init];
    for (int x = 0; x < query.items.count; x++)
    {
        MPMediaItem *item = [query.items objectAtIndex:x];
        NSString *title = [item title];
        NSString *artist = [item artist];
        NSLog(@"%@, %@",title, artist);
        [songTitles addObject:title];
        [songArtists addObject:artist];
    }
    //mutableToNonmutable declared in property
    self.mutableToNonmutableTitles = [songTitles copy];
    self.mutableToNonmutableArtists = [songArtists copy];
    self.partyToUpload[@"Songs"] = self.mutableToNonmutableTitles;
    self.partyToUpload[@"SongArtists"] = self.mutableToNonmutableArtists;
    //empty array
    self.partyToUpload[@"votes"] = @[];
    if (self.imageFile) {
        //user has selected a picture and is not using baby picture
        self.partyToUpload[@"imageOfParty"] = self.imageFile;
    } else {
        //user wants to use baby picture
        UIImage *chosenImage = [UIImage imageNamed:@"Image"];
        NSData *data=UIImagePNGRepresentation(chosenImage);
        PFFile *fileToSubmit = [PFFile fileWithName:@"image.png" data:data];
        self.partyToUpload[@"imageOfParty"] = fileToSubmit;
        
    }
    
    PFUser *currentU = [PFUser currentUser];
    NSString *userIDCurrentUser = currentU.objectId;
    self.partyToUpload[@"createdBy"] = userIDCurrentUser;
    
    //the following code block is to delete parties created by the same user as a single user should only have one party open at a time
    PFQuery *parseQuery = [PFQuery queryWithClassName:@"Party"];
    [parseQuery whereKey:@"createdBy" equalTo:userIDCurrentUser];
    NSArray *repeatedParties = [parseQuery findObjects];
    for (int x = 0; x < repeatedParties.count; x++)
    {
        PFObject *object = [repeatedParties objectAtIndex:x];
        [object deleteEventually];
    }
    
    

    [self.partyToUpload saveInBackground];
}




-(void)dismissKeyboard {
    [self.nameOfGroup resignFirstResponder];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    self.selectedMediaItemCollection = mediaItemCollection;
    /*
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
    */
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
    NSLog(@"new song playing!");
    MPMediaItem *currentItem = [_musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    
    //[_artworkImage setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        //_titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        //_titleLabel.text = @"Title: Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        //_artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        //_artistLabel.text = @"Artist: Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        //_albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        //_albumLabel.text = @"Album: Unknown album";
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
    [self registerMediaPlayerNotifcations];
    NSLog(@"in view didload method");
    //first time the view loads, there is no value for hasPickedAnImage. when user slects photo from camera or photo collection, this becomes true
    if (!self.hasPickedAnImage) {
        self.partyImage.image = [UIImage imageNamed:@"Image"];
    }
    
    //to create circlular image
    self.partyImage.layer.cornerRadius = self.partyImage.frame.size.width / 2;
    self.partyImage.clipsToBounds = YES;
    
    //to dismiss keyboard, regognize taps
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //is this needed?
    [MPVolumeView alloc];
    [super viewDidLoad];
    
    
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

- (IBAction)setGroupImage:(id)sender {
    [self showProfilePicturePopupWithStyle:CNPPopupStyleCentered];
    
}

- (void)showProfilePicturePopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Set Profile Picture" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Before you can create a debate, you must set a profile picture. You can use your iOS device's camera or select a photo from your phone." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    //from camera button
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"Photo from Camera" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        [self takePhoto];
        
    };
    
    //from existing Photos button
    CNPPopupButton *button2= [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button2 setTitle:@"Existing Photos" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button2.layer.cornerRadius = 4;
    button2.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        [self selectPhoto];
        
    };
    
    //close the popup
    CNPPopupButton *button3 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button3 setTitle:@"Close Me" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button3.layer.cornerRadius = 4;
    button3.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button1, button2, button3]];
    
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *data=UIImagePNGRepresentation(chosenImage);
    self.imageFile = [PFFile fileWithName:@"image.png" data:data];
    [self.partyImage setImage:chosenImage];
    self.hasPickedAnImage = TRUE;
    
    //[imageFile saveInBackground];
    
    
    //[self.currentUser setObject:imageFile forKey:@"profilePicture"];
    //[self.currentUser saveInBackground];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self viewDidLoad];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"in textFieldShouldReturn: method");
    [_nameOfGroup resignFirstResponder];
    return NO;
}


#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
    
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toCreatorMainPage"]) {
        
        // Get reference to the destination view controller
        CreatorTableViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setMediaItemCollection:self.selectedMediaItemCollection];
        [vc setPartyUploaded:self.partyToUpload];
        
    }
}

@end
