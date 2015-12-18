//
//  PlayingCardGameViewController.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.numberOfCards = 20;
    
    [self updateCardsToMatch];
    [self updateUI];
}

-(void) createCards
{
    for (int i = 0; i < self.cardGrid.minimumNumberOfCells; i++) {
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:tapRecognizer];
        
        [self.cardViews addObject:cardView];
        [self.cardSuperView addSubview:cardView];
    }
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    if ([sender.view isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *tappedView = (PlayingCardView *) sender.view;
        
        [UIView transitionWithView:sender.view
                          duration:0.5
                           options: UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                               Card *card = [self.game cardAtIndex: tappedView.cardIndex];
                               card.chosen = !card.chosen;
                           } completion:^(BOOL finished) {
                               Card *card = [self.game cardAtIndex: tappedView.cardIndex];
                               card.chosen = !card.chosen;
                               [self.game chooseCardAtIndex:tappedView.cardIndex];
                               [self updateUI];
                           }];
        [self updateUI];
        [super updateScore];
    }
}

-(void)updateUI
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setCardViewFrames];
    } completion:nil];
    
    if (self.resetWasPressed)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = [self.cardGrid frameOfCellAtRow:0 inColumn:0];
            
            for (UIView *subView in self.cardViews) {
                subView.frame = CGRectMake(frame.origin.x,
                                           frame.origin.y,
                                           frame.size.width,
                                           frame.size.height);
            }
        } completion:nil];
        
        [UIView animateWithDuration:0.5 delay: 1.0 options: UIViewAnimationOptionTransitionNone animations:^{
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
        } completion:nil];
    }
    
    int indexOfView = 0;
    for (int i = 0; i < self.game.numberOfCardsPlayed; i++) {
        PlayingCardView *cardView = [self.cardViews objectAtIndex:indexOfView];
        
        NSUInteger cardIndex = i;
        Card *card = [self.game cardAtIndex:cardIndex];
        
        if (![card isMatched]) {
            if ([card isKindOfClass:[PlayingCard class]]) {
                PlayingCard *playingCard = (PlayingCard *)card;
                cardView.rank = playingCard.rank;
                cardView.suit = playingCard.suit;
                
                if (!card.isChosen)
                {
                    cardView.faceUp = NO;
                } else {
                    cardView.faceUp = YES;
                }
                
                cardView.cardIndex = cardIndex;
                indexOfView++;
            }
        }
    }
    [super updateScore];
}

- (void)updateCardsToMatch
{
    self.game.cardsToMatch = 2;
}

@end
