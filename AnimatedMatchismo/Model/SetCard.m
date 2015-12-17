//
//  SetCard.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 15/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "SetCard.h"
#import <UIKit/UIKit.h>

@implementation SetCard

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSMutableSet *numberSet = [[NSMutableSet alloc] initWithObjects:@(self.number), nil];
    NSMutableSet *symbolSet = [[NSMutableSet alloc] initWithObjects:@(self.symbol), nil];
    NSMutableSet *colorSet = [[NSMutableSet alloc] initWithObjects:@(self.color), nil];
    NSMutableSet *shadingSet = [[NSMutableSet alloc] initWithObjects:self.shading, nil];
    
    for (SetCard *otherCard in otherCards) {
        [numberSet addObject: @(otherCard.number)];
        [symbolSet addObject: @(otherCard.symbol)];
        [colorSet addObject: @(otherCard.color)];
        [shadingSet addObject: otherCard.shading];
    }
    
    if ([numberSet count] == 1 || [numberSet count] == 3) {
        if ([symbolSet count] == 1 || [symbolSet count] == 3) {
            if ([colorSet count] == 1 || [colorSet count] == 3) {
                if ([shadingSet count] == 1 || [shadingSet count] == 3) {
                    score = 4;
                }
            }
        }
    }
    
    return score;
}

-(void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

+ (NSUInteger) maxNumber
{
    return 3;
}

-(void)setSymbol:(NSUInteger)symbol
{
    if (symbol <= [SetCard maxSymbol]) {
        _symbol = symbol;
    }
}

+ (NSUInteger) maxSymbol
{
    return [self maxNumber];
}

-(void)setColor:(NSUInteger)color
{
    if (color <= [SetCard maxColor]) {
        _color = color;
    }
}

+ (NSUInteger) maxColor
{
    return [self maxNumber];
}

@synthesize shading = _shading;

+ (NSArray *) validShading
{
    return @[@"solid", @"striped", @"open"];
}

-(void)setShading:(NSString *)shading
{
    if ([[SetCard validShading] containsObject:shading]) {
        _shading = shading;
    }
}

-(NSString *)shading
{
    return _shading ? _shading : @"?";
}

@end
