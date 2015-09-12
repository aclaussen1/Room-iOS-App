//
//  VoteCasted.m
//  SongQ
//
//  Created by Alexander Claussen on 9/12/15.
//  Copyright (c) 2015 com.MudLord. All rights reserved.
//

#import "VoteCasted.h"

@implementation VoteCasted

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)homeButton:(id)sender {
    [self performSegueWithIdentifier:@"toHome" sender:self];
}

@end
