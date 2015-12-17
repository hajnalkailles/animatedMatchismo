//
//  SetGameViewController.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self updateCardsToMatch];
    [self updateUI];
}

- (NSUInteger) numberOfCardsForGame
{
    return 12;
}

-(void) createCards
{
    for (int i = 0; i < self.cardGrid.minimumNumberOfCells; i++) {
        CGRect frame = [self.cardGrid frameOfCellAtRow:i/4 inColumn:i%4];
        
        CGFloat widthSpace = (self.cardSuperView.bounds.size.width-4*frame.size.width)/5;
        
        SetCardView *cardView = [[SetCardView alloc] initWithFrame: CGRectMake(frame.origin.x+(i%4+1)*widthSpace, frame.origin.y+4*(i/4+1), frame.size.width, frame.size.height)];
        //set center
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:tapRecognizer];
        
        [self.cardViews addObject:cardView];
        [self.cardSuperView addSubview:cardView];
    }
}

-(void)tap:(UIGestureRecognizer *)sender
{
    if ([sender.view isKindOfClass:[SetCardView class]]) {
        SetCardView *tappedView = (SetCardView *) sender.view;
        
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
        SetCardView *cardView = [self.cardViews objectAtIndex:indexOfView];
        
        NSUInteger cardIndex = i;
        Card *card = [self.game cardAtIndex:cardIndex];
        
        if (![card isMatched]) {
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard *setCard = (SetCard *)card;
                cardView.number = setCard.number;
                cardView.symbol = setCard.symbol;
                cardView.shading = setCard.shading;
                cardView.color = setCard.color;
                
                if (!card.isChosen)
                {
                    cardView.selected = NO;
                } else {
                    cardView.selected = YES;
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
    self.game.cardsToMatch = 3;
}

- (UIImage *) backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfrontSelected" : @"cardfront"];
}

- (NSAttributedString *) titleForCard:(Card *)card
{
    return card.attributedContents;
}


@end
