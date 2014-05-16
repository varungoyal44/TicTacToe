//
//  VGGamePlayViewController.m
//  TicTacToe
//
//  Created by Varun Goyal on 8/17/13.
//  Copyright (c) 2013 varungoyal. All rights reserved.
//

#import "VGGamePlayViewController.h"
#import "VGConstants.h"

#define PLAYER1 44
#define PLAYER2 84
#define BLANK 99

@interface VGGamePlayViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelPlayerTurn;

@property (strong, nonatomic) IBOutlet UIButton *button00;
@property (strong, nonatomic) IBOutlet UIButton *button01;
@property (strong, nonatomic) IBOutlet UIButton *button02;

@property (strong, nonatomic) IBOutlet UIButton *button10;
@property (strong, nonatomic) IBOutlet UIButton *button11;
@property (strong, nonatomic) IBOutlet UIButton *button12;

@property (strong, nonatomic) IBOutlet UIButton *button20;
@property (strong, nonatomic) IBOutlet UIButton *button21;
@property (strong, nonatomic) IBOutlet UIButton *button22;

@property (strong, nonatomic) NSArray *buttonRankedArray;

@property (strong, nonatomic) IBOutlet UIButton *buttonBack;
@property (strong, nonatomic) IBOutlet UIButton *buttonRematch;

@property int currentPlayer;
@property int turnsPlayed;

@property int player1WinCount;
@property int player2WinCount;

@end

@implementation VGGamePlayViewController
@synthesize labelPlayerTurn = _labelPlayerTurn;

@synthesize button00 = _button00;
@synthesize button01 = _button01;
@synthesize button02 = _button02;

@synthesize button10 = _button10;
@synthesize button11 = _button11;
@synthesize button12 = _button12;

@synthesize button20 = _button20;
@synthesize button21 = _button21;
@synthesize button22 = _button22;

@synthesize buttonRankedArray = _buttonRankedArray;

@synthesize buttonBack = _buttonBack;
@synthesize buttonRematch = _buttonRematch;

@synthesize currentPlayer = _currentPlayer;
@synthesize turnsPlayed = _turnsPlayed;

@synthesize player1Piece = _player1Piece;
@synthesize player2Piece = _player2Piece;

@synthesize player1WinCount = _player1WinCount;
@synthesize player2WinCount = _player2WinCount;

@synthesize isPVE = _isPVE;

#pragma mark- LIFECYCLE
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    // To set the buttons in the array, in a ranked order...
    self.buttonRankedArray = [[NSArray alloc] initWithObjects:
                              self.button11,
                              
                              self.button00,
                              self.button02,
                              self.button20,
                              self.button22,
                              
                              self.button01,
                              self.button10,
                              self.button12,
                              self.button21,
                              nil];
    
    // To set the button press event for the
    for(UIButton *thisButton in self.buttonRankedArray)
    {
        [thisButton addTarget:self action:@selector(chancePlayed:) forControlEvents:UIControlEventTouchUpInside];
        [thisButton setTag:BLANK];
    }
    
    // setting default values...
    self.currentPlayer = PLAYER1;
    self.player1WinCount = 0;
    self.player2WinCount = 0;
    self.turnsPlayed = 0;
    
    // To set the notification for the bot to play if PVE is set...
    if(self.isPVE)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(botPlayYourTurn:)
                                                     name:@"Player2 Turn"
                                                   object:nil];
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // setting background...
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_BACKGROUND]]];
    
    // hiding back button...
    [self.navigationItem setBackBarButtonItem:nil];
    
    // setting default states...
    [self.labelPlayerTurn setText:@"Player 1, Play!"];
    [self setTitle:@""];
    [self.buttonRematch setHidden:YES];
    
    // setting button highlight state...
    [self.buttonBack setImage:[UIImage imageNamed:@"button-back-highlight.png"] forState:UIControlStateHighlighted];
    [self.buttonRematch setImage:[UIImage imageNamed:@"button-rematch-highlight.png"] forState:UIControlStateHighlighted];
}

#pragma mark- BUTTON PRESS
- (void) chancePlayed:(UIButton *) thisButton
{
    if(self.currentPlayer == PLAYER1)
    {
        [thisButton setImage:self.player1Piece forState:UIControlStateNormal];
        [thisButton setUserInteractionEnabled:NO];
        [thisButton setTag:PLAYER1];
        
        [self.labelPlayerTurn setText:@"Player 2, Play!"];
        self.currentPlayer = PLAYER2;
        self.turnsPlayed++;
        if(![self didPlayerWinOrDraw])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"Player2 Turn"
             object:self
             userInfo:[NSDictionary dictionaryWithObject:thisButton forKey:@"buttonPressed"]];
        }
    }
    
    else
    {
        [thisButton setImage:self.player2Piece forState:UIControlStateNormal];
        [thisButton setUserInteractionEnabled:NO];
        
        [thisButton setTag:PLAYER2];
        [self.labelPlayerTurn setText:@"Player 1, Play!"];
        self.currentPlayer = PLAYER1;
        self.turnsPlayed++;
        [self didPlayerWinOrDraw];
    }
}

- (IBAction)buttonRematchPressed:(id)sender
{
    self.currentPlayer = PLAYER1;
    for(UIButton *thisButton in self.buttonRankedArray)
    {
        [thisButton setImage:nil forState:UIControlStateNormal];
        [thisButton setUserInteractionEnabled:YES];
        [thisButton setTag:BLANK];
    }
    [self.labelPlayerTurn setText:@"Player 1, Play!"];
    [self.buttonRematch setHidden:YES];
    [self setTitle:@""];
    self.turnsPlayed = 0;
}

- (IBAction)backbuttonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark- UTILITY
- (void) botPlayYourTurn: (NSNotification *) notification
{
    [self.labelPlayerTurn setText:@"Player 2, Thinking...."];
    //UIButton *previousButtonSelectedByUser = [notification.userInfo objectForKey:@"buttonPressed"];
    
    NSDictionary *buttonsToPlay = [self counterPlay];
    if([buttonsToPlay.allKeys containsObject:[NSNumber numberWithInt:PLAYER2]])
    {
        UIButton *thisButton = buttonsToPlay[[NSNumber numberWithInt:PLAYER2]];
        NSLog(@"buttons_Player2: %@", thisButton.titleLabel.text);
        [self chancePlayed:thisButton];
    }
    else
    {
        UIButton *thisButton = buttonsToPlay[[NSNumber numberWithInt:PLAYER1]];
        NSLog(@"buttons_Player1: %@", thisButton.titleLabel.text);
        [self chancePlayed:thisButton];
    }
}

- (NSDictionary *) counterPlay
{
    NSMutableDictionary *blockOrWin = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    
    // Top left tile...
    if(self.button00.tag != BLANK)
    {
        NSNumber *player = [NSNumber numberWithInt:self.button00.tag];
        if(self.button00.tag == self.button01.tag && self.button02.tag == BLANK)
            [blockOrWin setObject:self.button02 forKey:player];
        if (self.button00.tag == self.button11.tag && self.button22.tag == BLANK)
            [blockOrWin setObject:self.button22 forKey:player];
        if (self.button00.tag == self.button10.tag && self.button20.tag == BLANK)
            [blockOrWin setObject:self.button20 forKey:player];
        if(self.button00.tag == self.button02.tag && self.button01.tag == BLANK)
            [blockOrWin setObject:self.button01 forKey:player];
        if(self.button00.tag == self.button20.tag && self.button10.tag == BLANK)
            [blockOrWin setObject:self.button10 forKey:player];
        
    }
    // Top right tile...
    if(self.button02.tag != BLANK)
    {
        NSNumber *player = [NSNumber numberWithInt:self.button02.tag];
        if (self.button02.tag == self.button01.tag && self.button00.tag == BLANK)
            [blockOrWin setObject:self.button00 forKey:player];
        if (self.button02.tag == self.button11.tag && self.button20.tag == BLANK)
            [blockOrWin setObject:self.button20 forKey:player];
        if (self.button02.tag == self.button12.tag && self.button22.tag == BLANK)
            [blockOrWin setObject:self.button22 forKey:player];
    }
    
    // Bottom left tile...
    if(self.button20.tag != BLANK)
    {
        NSNumber *player = [NSNumber numberWithInt:self.button20.tag];
        if (self.button20.tag == self.button21.tag && self.button22.tag == BLANK)
            [blockOrWin setObject:self.button22 forKey:player];
        if (self.button20.tag == self.button11.tag && self.button02.tag == BLANK)
            [blockOrWin setObject:self.button02 forKey:player];
        if (self.button20.tag == self.button10.tag && self.button00.tag ==BLANK)
            [blockOrWin setObject:self.button00 forKey:player];
    }
    
    // Bottom right tile...
    if(self.button22.tag != BLANK)
    {
        NSNumber *player = [NSNumber numberWithInt:self.button22.tag];
        if (self.button22.tag == self.button12.tag && self.button02.tag==BLANK)
            [blockOrWin setObject:self.button02 forKey:player];
        if (self.button22.tag == self.button11.tag && self.button00.tag == BLANK)
            [blockOrWin setObject:self.button00 forKey:player];
        if (self.button22.tag == self.button21.tag && self.button20.tag == BLANK)
            [blockOrWin setObject:self.button20 forKey:player];
        if (self.button22.tag == self.button02.tag && self.button12.tag == BLANK)
            [blockOrWin setObject:self.button12 forKey:player];
        if (self.button22.tag == self.button20.tag && self.button21.tag == BLANK)
            [blockOrWin setObject:self.button21 forKey:player];
    }
    
    // Center tile...
    if(self.button11.tag != BLANK)
    {
        NSNumber *player = [NSNumber numberWithInt:self.button11.tag];
        if (self.button11.tag == self.button01.tag && self.button21.tag == BLANK)
            [blockOrWin setObject:self.button21 forKey:player];
        if (self.button11.tag == self.button21.tag && self.button01.tag == BLANK)
            [blockOrWin setObject:self.button01 forKey:player];
        if (self.button11.tag == self.button10.tag && self.button12.tag == BLANK)
            [blockOrWin setObject:self.button12 forKey:player];
        if (self.button11.tag == self.button12.tag && self.button10.tag == BLANK)
            [blockOrWin setObject:self.button10 forKey:player];
    }
    
    
    // If there is no blocking or winning tile to play then...
    if(blockOrWin.count == 0)
    {
        for(UIButton *thisButton in self.buttonRankedArray) // the buttons are added in ranked order...
        {
            if(thisButton.isUserInteractionEnabled)
            {
                NSNumber *player = [NSNumber numberWithInt:PLAYER2];
                [blockOrWin setObject:thisButton forKey:player];
                break;
            }
        }
    }
    
    
    return blockOrWin;
    
    
}


- (BOOL) didPlayerWinOrDraw
{
    BOOL reply = NO;
    if(
       (self.button00.tag != BLANK && self.button00.tag == self.button01.tag && self.button01.tag == self.button02.tag) ||
       (self.button10.tag != BLANK && self.button10.tag == self.button11.tag && self.button11.tag == self.button12.tag) ||
       (self.button20.tag != BLANK && self.button20.tag == self.button21.tag && self.button21.tag == self.button22.tag) ||
       
       (self.button00.tag != BLANK && self.button00.tag == self.button10.tag && self.button10.tag == self.button20.tag) ||
       (self.button01.tag != BLANK && self.button01.tag == self.button11.tag && self.button11.tag == self.button21.tag) ||
       (self.button02.tag != BLANK && self.button02.tag == self.button12.tag && self.button12.tag == self.button22.tag) ||
       
       (self.button00.tag != BLANK && self.button00.tag == self.button11.tag && self.button11.tag == self.button22.tag) ||
       (self.button02.tag != BLANK && self.button02.tag == self.button11.tag && self.button11.tag == self.button20.tag)
       )
    {
        
        for(UIButton *thisButton in self.buttonRankedArray)
        {
            [thisButton setUserInteractionEnabled:NO];
        }
        
        if(self.currentPlayer == PLAYER1)
        {
            NSLog(@"Player 2 wins");
            [self.labelPlayerTurn setText:@"Player 2 Wins!!!"];
            self.player2WinCount++;
            
        }
        else
        {
            NSLog(@"Player 1 wins");
            [self.labelPlayerTurn setText:@"Player 1 Wins!!!"];
            self.player1WinCount++;
        }
        
        reply = YES;
    }
    
    
    else if(self.turnsPlayed == 9)
    {
        NSLog(@"its a Draw");
        [self.labelPlayerTurn setText:@"Its a Draw!!!"];
        reply = YES;
    }
    
    if(reply == YES)
    {
        [self setTitle:[NSString stringWithFormat:@"P1:%d      P2:%d", self.player1WinCount, self.player2WinCount]];
        [self.buttonRematch setHidden:NO];
    }
    
    return reply;
}


#pragma mark- END
@end
