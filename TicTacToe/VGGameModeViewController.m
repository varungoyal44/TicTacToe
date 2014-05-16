//
//  VGGameModeViewController.m
//  TicTacToe
//
//  Created by Varun Goyal on 8/21/13.
//  Copyright (c) 2013 varungoyal. All rights reserved.
//

#import "VGGameModeViewController.h"
#import "VGConstants.h"
#import "VGGamePlayViewController.h"


@interface VGGameModeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *gameModePVP;
@property (strong, nonatomic) IBOutlet UIButton *gameModePVE;
@property (strong, nonatomic) IBOutlet UIButton *startingPieceX;
@property (strong, nonatomic) IBOutlet UIButton *startingPieceO;
@property (strong, nonatomic) IBOutlet UIButton *buttonCancel;
@property (strong, nonatomic) IBOutlet UIButton *buttonCreate;

@end

@implementation VGGameModeViewController


#pragma mark- LIFECYCLE
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // setting background...
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_BACKGROUND]]];

    // hiding navigation bar...
    [self.navigationController setNavigationBarHidden:YES];
    
    // setting UI elements for button clicks...
    [self.gameModePVP setImage:[UIImage imageNamed:@"pvp.png"] forState:UIControlStateSelected];
    [self.gameModePVE setImage:[UIImage imageNamed:@"pve.png"] forState:UIControlStateSelected];
    [self.startingPieceX setImage:[UIImage imageNamed:IMAGE_PIECE_X_BLUE] forState:UIControlStateSelected];
    [self.startingPieceO setImage:[UIImage imageNamed:IMAGE_PIECE_O_BLUE] forState:UIControlStateSelected];
    [self.buttonCancel setImage:[UIImage imageNamed:@"button-cancel-highlight.png"] forState:UIControlStateHighlighted];
    [self.buttonCreate setImage:[UIImage imageNamed:@"button-create-highlight.png"] forState:UIControlStateHighlighted];

    // setting selected state...
    [self.gameModePVP setSelected:YES];
    [self.startingPieceX setSelected:YES];
    
    [self.gameModePVE setSelected:NO];
    [self.startingPieceO setSelected:NO];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark- BUTTON PRESS
- (IBAction)buttonCancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gameModePVPPressed:(id)sender
{
    [self.gameModePVP setSelected:YES];
    [self.gameModePVE setSelected:NO];
}

- (IBAction)gameModePVEPressed:(id)sender
{
    [self.gameModePVP setSelected:NO];
    [self.gameModePVE setSelected:YES];
}

- (IBAction)startingPieceXPressed:(id)sender
{
    [self.startingPieceX setSelected:YES];
    [self.startingPieceO setSelected:NO];
}

- (IBAction)startingPieceOPressed:(id)sender
{
    [self.startingPieceX setSelected:NO];
    [self.startingPieceO setSelected:YES];
}

- (IBAction)buttonCreatePressed:(id)sender
{
    [self performSegueWithIdentifier:@"goGamePlay" sender:self];
}


#pragma mark- UTILITY
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goGamePlay"])
    {
        VGGamePlayViewController *gamePlayViewController = (VGGamePlayViewController *) segue.destinationViewController;
        gamePlayViewController.isPVE = self.gameModePVE.selected;
        if(self.startingPieceX.selected)
        {
            gamePlayViewController.player1Piece = [UIImage imageNamed:IMAGE_PIECE_X_BLUE];
            gamePlayViewController.player2Piece = [UIImage imageNamed:IMAGE_PIECE_O_BLUE];
        }
        else
        {
            gamePlayViewController.player1Piece = [UIImage imageNamed:IMAGE_PIECE_O_BLUE];
            gamePlayViewController.player2Piece = [UIImage imageNamed:IMAGE_PIECE_X_BLUE];
        }
    }
}


#pragma mark- END
@end
