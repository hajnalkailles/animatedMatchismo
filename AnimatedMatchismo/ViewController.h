//
//  ViewController.h
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 14/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"
#import "Grid.h"
#import "PlayingCardView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, strong) Grid *cardGrid;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *cardSuperView;

@property (nonatomic) BOOL resetWasPressed;

// protected
// for subclasses
- (Deck *)createDeck;   //abstract
- (void)updateUI;
- (void)updateScore;
- (NSUInteger) numberOfCardsForGame;

@end

