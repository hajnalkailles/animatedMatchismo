//
//  SetCardDeck.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger symbol = 1; symbol <= [SetCard maxSymbol]; symbol++) {
            for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
                for (NSUInteger color = 1; color <= [SetCard maxColor]; color++) {
                    for (NSString *shading in [SetCard validShading]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.number = number;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card];
                        self.cardsInDeck++;
                    }
                }
            }
        }
    }
    
    return self;
}

@end
