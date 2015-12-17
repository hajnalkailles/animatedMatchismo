//
//  SetCard.h
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "Card.h"
#import <UIKit/UIKit.h>

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger color;
@property (strong, nonatomic) NSString *shading;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShading;
+ (NSUInteger)maxNumber;
+ (NSUInteger)maxSymbol;
+ (NSUInteger)maxColor;

@end
