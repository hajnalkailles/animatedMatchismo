//
//  CardMatchingGame.h
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;

-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card*)cardAtIndex:(NSUInteger)index;

-(void)addNewCard;
-(NSUInteger)numberOfCardsPlayed;
-(NSUInteger)numberOfCardsInDeck;

@property (nonatomic, strong) Deck *cardDeck;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSInteger cardsToMatch;   //gameplay mode

@end
