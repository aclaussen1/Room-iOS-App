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

@interface CreatePartyViewController ()

@end

@implementation CreatePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFObject *testObject = [PFObject objectWithClassName:@"Party"];
    testObject[@"test"] = @"bar";
    [testObject saveInBackground];
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
