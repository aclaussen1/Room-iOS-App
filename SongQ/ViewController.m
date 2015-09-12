//
//  ViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/11/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CreatorTableViewController.h"

@interface ViewController ()
@property MPMediaItemCollection * selectedMediaItemCollection;
@property PFObject *partyToUpload;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", currentUser);
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)logout:(id)sender {
    [self performSegueWithIdentifier:@"logout" sender:self];
}

- (IBAction)unwindFromPageToMain:(UIStoryboardSegue *)segue
{
    NSLog(@"moving back to main page");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toCreatorMainPage"]) {
        
        // Get reference to the destination view controller
        CreatorTableViewController *vc = [segue destinationViewController];
        
        PFUser *currentU = [PFUser currentUser];
        NSString *userIDCurrentUser = currentU.objectId;
        //the following code block is to delete parties created by the same user as a single user should only have one party open at a time
        PFQuery *parseQuery = [PFQuery queryWithClassName:@"Party"];
        [parseQuery whereKey:@"createdBy" equalTo:userIDCurrentUser];
        PFObject *party = [parseQuery getFirstObject];
        // Pass any objects to the view controller here, like...
        [vc setMediaItemCollection:self.selectedMediaItemCollection];
        [vc setPartyUploaded:party];
        
    }
}

@end
