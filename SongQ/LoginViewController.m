//
//  ViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/5/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "CNPPopupController.h"
#import <QuartzCore/QuartzCore.h>
#import "InternetConnectivity.h"

@interface LoginViewController () {
    UITextField *popupTextField;
    InternetConnectivity *internetReachableFoo;
}

@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UITextField *username1;
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (strong, nonatomic) NSArray *permissions;




@end

@implementation LoginViewController

//uses InternetConnectivity.m
- (void)testInternetConnection
{
    internetReachableFoo = [InternetConnectivity reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(InternetConnectivity*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(InternetConnectivity*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachableFoo startNotifier];
}

-(void)dismissKeyboard {
    [self.username1 resignFirstResponder];
    [self.password1 resignFirstResponder];
}


- (IBAction)unwindFromMainToLogin:(UIStoryboardSegue *)segue
{
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"current user: %@", currentUser.username);
    [PFUser logOut];
    NSLog(@"user logged out");
    
}


- (IBAction)continueAsGuest:(id)sender {
    NSLog(@"continuing as a guest and logging out");
    [PFUser logOut];
}



- (IBAction)reguarLogin:(id)sender {
    [PFUser logInWithUsernameInBackground:self.username1.text password:self.password1.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier: @"toMainPage" sender:self];
                                        } else {
                                            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username and/or password do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                            [errorAlertView show];
                                        }
                                    }];
}


- (void)viewDidLoad {
    //to dismiss keyboard, regognize taps
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    self.permissions = @[@"public_profile"];
    self.username1.delegate = self;
    self.password1.delegate = self;
    //Current user. It would be bothersome if the user had to log in every time they open your app. You can avoid this by using the cached currentUser object.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier: @"toMainPage" sender:self];
    } else {
        
    }
    
    //tests for an internet connection
    [self testInternetConnection];
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
