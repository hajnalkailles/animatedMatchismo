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

- (NSAttributedString *) attributedContents
{
    NSMutableString *title = [[NSMutableString alloc] initWithString: [NSString stringWithFormat:@"%@", @(self.symbol)]];
    int index = 1;
    while (index < self.number) {
        [title appendString: [NSString stringWithFormat:@"%@", @(self.symbol)]];
        index++;
    }
    NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] init];
    if ([self.shading isEqualToString:@"solid"]) {
        [attributesDictionary setObject:@-5 forKey:NSStrokeWidthAttributeName];
    } else if ([self.shading isEqualToString:@"striped"]) {
        [attributesDictionary setObject:@-7 forKey:NSStrokeWidthAttributeName];
        [attributesDictionary setObject:[UIColor blackColor] forKey:NSStrokeColorAttributeName];
    } else if ([self.shading isEqualToString:@"open"]) {
        [attributesDictionary setObject:@5 forKey:NSStrokeWidthAttributeName];
    }
    //[attributesDictionary setObject:self.color forKey:NSForegroundColorAttributeName];
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:title attributes: attributesDictionary];
    
    return titleString;
}

-(void)setSymbol:(NSUInteger)symbol
{
    if (symbol <= [SetCard maxSymbol]) {
        _symbol = symbol;
    }
}

-(void)setColor:(NSUInteger)color
{
    if (color <= [SetCard maxColor]) {
        _color = color;
    }
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

+ (NSUInteger) maxNumber
{
    return 3;
}

-(void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

+ (NSUInteger) maxSymbol
{
    return [self maxNumber];
}

+ (NSUInteger) maxColor
{
    return [self maxNumber];
}

@end
