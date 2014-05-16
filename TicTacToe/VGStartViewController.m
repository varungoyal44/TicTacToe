//
//  VGStartViewController.m
//  TicTacToe
//
//  Created by Varun Goyal on 8/17/13.
//  Copyright (c) 2013 varungoyal. All rights reserved.
//

#import "VGStartViewController.h"
#import "VGConstants.h"

@interface VGStartViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButtonSmall;

@end

@implementation VGStartViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_BACKGROUND]]];
    
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"button-new-game.png"]
                                forState:UIControlStateNormal];
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"button-new-game-highlight.png"]
                                forState:UIControlStateHighlighted];

    
    [self.startButtonSmall setBackgroundImage:[UIImage imageNamed:@"button-new-game-small.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.startButtonSmall setBackgroundImage:[UIImage imageNamed:@"button-new-game-small-highlight.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

}

@end
