//
//  SetCardView.h
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 16/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) BOOL selected;

@property (nonatomic) NSUInteger cardIndex;

@end
