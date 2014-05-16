//
//  VGGamePlayViewController.h
//  TicTacToe
//
//  Created by Varun Goyal on 8/17/13.
//  Copyright (c) 2013 varungoyal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGGamePlayViewController : UIViewController

@property (weak, nonatomic) UIImage *player1Piece;
@property (weak, nonatomic) UIImage *player2Piece;

@property BOOL isPVE;

@end
