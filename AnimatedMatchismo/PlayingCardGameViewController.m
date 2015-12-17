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
    [self updateCardsToMatch];
    [self updateUI];
}

- (NSUInteger) numberOfCardsForGame
{
    return 20;
}

-(void) createCards
{
    //remove magic number 4
    for (int i = 0; i < self.cardGrid.minimumNumberOfCells; i++) {
        CGRect frame = [self.cardGrid frameOfCellAtRow:i/4 inColumn:i%4];
        
        CGFloat widthSpace = (self.cardSuperView.bounds.size.width-4*frame.size.width)/5;
        
        PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame: CGRectMake(frame.origin.x+(i%4+1)*widthSpace, frame.origin.y+4*(i/4+1), frame.size.width, frame.size.height)];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(tap:)];
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
    if (self.resetWasPressed)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = [self.cardGrid frameOfCellAtRow:0 inColumn:0];
            CGFloat widthSpace = (self.cardSuperView.bounds.size.width-4*frame.size.width)/5;
            
            for (UIView *subView in self.cardViews) {
                subView.frame = CGRectMake(frame.origin.x+widthSpace,
                                           frame.origin.y+4,
                                           frame.size.width,
                                           frame.size.height);
            }
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:0.5 delay: 1.0 options: UIViewAnimationOptionTransitionNone animations:^{
            int i = 0;
            for (UIView *view in self.cardViews) {
                CGRect frame = [self.cardGrid frameOfCellAtRow:i/4 inColumn:i%4];
                CGFloat widthSpace = (self.cardSuperView.bounds.size.width-4*frame.size.width)/5;
                view.frame = CGRectMake(frame.origin.x+(i%4+1)*widthSpace,
                                        frame.origin.y+4*(i/4+1),
                                        frame.size.width,
                                        frame.size.height);
                i++;
            }
            } completion:^(BOOL finished){
        }];
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
