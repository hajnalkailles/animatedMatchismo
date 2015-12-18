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
        _cardGrid.size = CGSizeMake(self.cardSuperView.bounds.size.width, self.cardSuperView.bounds.size.height);
        _cardGrid.minimumNumberOfCells = self.numberOfCards;
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

-(void) createCards
{
}

- (void)updateUI  //abstract
{
}

-(void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateCardsToMatch  //abstract
{
}

-(void)setCardViewFrames
{
    int cardViewIndex = 0;
    for (int row = 0; row < self.cardGrid.rowCount; row++) {
        for (int col = 0; col < self.cardGrid.columnCount; col++) {
            if (cardViewIndex < self.cardGrid.minimumNumberOfCells) {
                UIView *view = [self.cardViews objectAtIndex:cardViewIndex];
                
                CGRect frame = [self.cardGrid frameOfCellAtRow:row inColumn:col];
                view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                
                cardViewIndex++;
            }
        }
    }
}

- (IBAction)touchResetButton:(UIButton *)sender
{
    self.resetWasPressed = YES;
    self.game = nil;
    [self updateUI];
    [self updateCardsToMatch];
    self.resetWasPressed = NO;
}

@end
