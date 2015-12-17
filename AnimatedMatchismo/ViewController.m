//
//  ViewController.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 14/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation ViewController

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardGrid.minimumNumberOfCells
                                                  usingDeck:[self createDeck]];
    return _game;
}

- (Deck *) createDeck   //abstract
{
    return nil;
}

- (Grid *) cardGrid
{
    if (!_cardGrid)
    {
        _cardGrid = [[Grid alloc] init];
        _cardGrid.cellAspectRatio = 0.68;
        CGSize tempSize = CGSizeMake(self.cardSuperView.bounds.size.width, self.cardSuperView.bounds.size.height);
        _cardGrid.size = tempSize;
        _cardGrid.minimumNumberOfCells = [self numberOfCardsForGame];
        if (_cardGrid.inputsAreValid)
            NSLog(@"Inputs are valid.");
    }
    
    return _cardGrid;
}

- (NSMutableArray *) cardViews
{
    if (!_cardViews)
    {
        _cardViews = [[NSMutableArray alloc] init];
        [self createCards];
    }
    
    return _cardViews;
}

- (NSUInteger) numberOfCardsForGame
{
    return 0;
}

- (void)createCards
{
}

- (void)updateUI
{
}

-(void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateCardsToMatch  //abstract
{
}

- (IBAction)touchResetButton:(UIButton *)sender
{
    self.resetWasPressed = YES;
    self.game = nil;
    [self updateUI];
    [self updateCardsToMatch];
    self.resetWasPressed = NO;
}

- (NSAttributedString *) titleForCard:(Card *)card  //abstract
{
    return nil;
}

- (UIImage *) backgroundImageForCard:(Card *)card   //abstract
{
    return nil;
}

-(void)viewDidLoad
{
    
}

@end
