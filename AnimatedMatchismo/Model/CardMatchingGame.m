//
//  CardMatchingGame.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "CardMatchingGame.h"
#import "SetCard.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSUInteger cardsPlayed;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
{
    self = [super init];
    self.cardsPlayed = 0;
    
    if (self) {
        self.cardDeck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [self.cardDeck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
                self.cardsPlayed++;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void) chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }
            if ([otherCards count] == self.cardsToMatch-1) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    Card *card = [self.cardDeck drawRandomCard];
                    if (card) {
                        [self.cards addObject:card];
                        self.cardsPlayed++;
                    }
                    for (Card *card in otherCards) {
                        card.matched = YES;
                        Card *card = [self.cardDeck drawRandomCard];
                        if (card) {
                            [self.cards addObject:card];
                            self.cardsPlayed++;
                        }
                    }
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *card in otherCards) {
                        card.chosen = NO;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)addNewCard
{
    Card *card = [self.cardDeck drawRandomCard];
    if (card) {
        [self.cards addObject:card];
        self.cardsPlayed++;
    }
}

- (NSUInteger)numberOfCardsPlayed
{
    return self.cardsPlayed;
}

- (NSUInteger)numberOfCardsInDeck
{
    return self.cardDeck.cardsInDeck;
}

- (instancetype)init
{
    return nil;
}


@end
