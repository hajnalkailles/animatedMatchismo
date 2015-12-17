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
    
    NSMutableSet *symbolSet = [[NSMutableSet alloc] init];
    NSMutableSet *numberSet = [[NSMutableSet alloc] init];
    NSMutableSet *shadingSet = [[NSMutableSet alloc] init];
    NSMutableSet *colorSet = [[NSMutableSet alloc] init];
    
    [symbolSet addObject: @(self.symbol)];
    [numberSet addObject: @(self.number)];
    [shadingSet addObject: self.shading];
    [colorSet addObject: @(self.color)];
    
    for (SetCard *otherCard in otherCards) {
        [symbolSet addObject: @(otherCard.symbol)];
        [numberSet addObject: @(otherCard.number)];
        [shadingSet addObject: otherCard.shading];
        [colorSet addObject: @(otherCard.color)];
    }
    
    if ([symbolSet count] == 1 || [symbolSet count] == 3) {
        if ([numberSet count] == 1 || [numberSet count] == 3) {
            if ([shadingSet count] == 1 || [shadingSet count] == 3) {
                if ([colorSet count] == 1 || [colorSet count] == 3) {
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

@synthesize symbol = _symbol;

+ (NSArray *) validSymbols
{
    return @[@"◼︎",@"▲",@"●"];
}

-(void)setSymbol:(NSUInteger)symbol
{
    if (symbol <= [SetCard maxSymbol]) {
        _symbol = symbol;
    }
}

@synthesize color = _color;

+ (NSArray *) validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor orangeColor]];
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
    return [[self validSymbols] count];
}

-(void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

+ (NSUInteger) maxSymbol
{
    return [[self validSymbols] count];
}

+ (NSUInteger) maxColor
{
    return [[self validColors] count];
}

@end
