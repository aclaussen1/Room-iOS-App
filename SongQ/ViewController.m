//
//  ViewController.m
//  SongQ
//
//  Created by Alexander Claussen on 9/11/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "ViewController.h"
#import "Parse/Parse.h"

@interface ViewController ()

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
