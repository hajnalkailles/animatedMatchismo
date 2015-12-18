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
@property (weak, nonatomic) IBOutlet UIButton *moreCardsButton;
@end

@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.numberOfCards = 12;
    
    [self updateCardsToMatch];
    [self updateUI];
}

- (IBAction)touchMoreCardsButton:(UIButton *)sender {
    int i = 0;
    while ((([self.game numberOfCardsInDeck]-self.game.numberOfCardsPlayed) > 0) && (i < 3)) {
        self.cardGrid.minimumNumberOfCells++;
        self.numberOfCards++;
        i++;
    }
    [self addCards:i];
    [self updateUI];
}

-(void) addCards:(NSUInteger)numberOfCardsToAdd
{
    for (int i = 0; i < numberOfCardsToAdd; i++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:tapRecognizer];
        
        [self.cardViews addObject:cardView];
        [self.cardSuperView addSubview:cardView];
        
        [self.game addNewCard];
    }
}

-(void) createCards
{
    for (int i = 0; i < self.cardGrid.minimumNumberOfCells; i++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
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
                           options: UIViewAnimationOptionTransitionNone animations:^{
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
        } completion: nil];
        
        [UIView animateWithDuration:0.5 delay: 1.0 options: UIViewAnimationOptionTransitionNone animations:^{
            self.numberOfCards = 12;
            self.cardGrid = nil;
            self.game = nil;
            self.cardViews = nil;
            [self createCards];
            
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

@end
