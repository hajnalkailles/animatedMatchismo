//
//  SetCardView.m
//  AnimatedMatchismo
//
//  Created by Hegyi Hajnalka on 16/12/15.
//  Copyright © 2015 Hegyi Hajnalka. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation SetCardView

#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSUInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (!self.selected) {
        [[UIImage imageNamed:@"cardfront"] drawInRect:self.bounds];
        [self drawShape];
    } else {
        [[UIImage imageNamed:@"cardfrontSelected"] drawInRect:self.bounds];
        [self drawShape];
    }
}

#pragma mark - Shapes

#define SHAPE_OFFSET2_PERCENTAGE 0.165
#define SHAPE_OFFSET3_PERCENTAGE 0.175

- (void)drawShape
{
    switch (self.number) {
        case 1:
            [self drawShapeWithHorizontalOffset:0 verticalOffset:0];
            break;
        case 2:
            [self drawShapeWithHorizontalOffset:0 verticalOffset: SHAPE_OFFSET2_PERCENTAGE];
            [self drawShapeWithHorizontalOffset:0 verticalOffset: -SHAPE_OFFSET2_PERCENTAGE];
            break;
        default:
            [self drawShapeWithHorizontalOffset:0 verticalOffset:0];
            [self drawShapeWithHorizontalOffset:0 verticalOffset:SHAPE_OFFSET3_PERCENTAGE];
            [self drawShapeWithHorizontalOffset:0 verticalOffset:-SHAPE_OFFSET3_PERCENTAGE];
            break;
    }
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawShapeWithHorizontalOffset:(CGFloat)hoffset
                       verticalOffset:(CGFloat)voffset
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //determine somehow symbol size
    CGSize symbolSize = CGSizeMake(15, 15);
    CGSize squiggleSize = CGSizeMake(30, 15);
    UIBezierPath *symbolPath = [[UIBezierPath alloc] init];
    
    switch (self.symbol)
    {
        case 1:
            [symbolPath moveToPoint:CGPointMake(middle.x,
                                                middle.y-symbolSize.height/2.0-voffset*self.bounds.size.height)];
            [symbolPath addLineToPoint:CGPointMake(middle.x+symbolSize.width/2.0+hoffset*self.bounds.size.width+5, middle.y-voffset*self.bounds.size.height)];
            [symbolPath addLineToPoint:CGPointMake(middle.x, middle.y+symbolSize.height/2.0-voffset*self.bounds.size.height)];
            [symbolPath addLineToPoint:CGPointMake(middle.x-symbolSize.width/2.0-hoffset*self.bounds.size.width-5, middle.y-voffset*self.bounds.size.height)];
            [symbolPath closePath];
            break;
        case 2:
            symbolPath = [UIBezierPath bezierPathWithOvalInRect:
                          CGRectMake(middle.x-symbolSize.width-hoffset*self.bounds.size.width,
                                     middle.y-symbolSize.height/2.0-voffset*self.bounds.size.height,
                                     (middle.x-(middle.x-symbolSize.width/2.0-hoffset*self.bounds.size.width))*4,
                                     (middle.y-(middle.y-symbolSize.height/2.0))*2)];
            break;
        default:
        {
            [symbolPath moveToPoint:CGPointMake(104, 15)];
            [symbolPath addCurveToPoint:CGPointMake(63, 54) controlPoint1:CGPointMake(112.4, 36.9) controlPoint2:CGPointMake(89.7, 60.8)];
            [symbolPath addCurveToPoint:CGPointMake(27, 53) controlPoint1:CGPointMake(52.3, 51.3) controlPoint2:CGPointMake(42.2, 42)];
            [symbolPath addCurveToPoint:CGPointMake(5, 40) controlPoint1:CGPointMake(9.6, 65.6) controlPoint2:CGPointMake(5.4, 58.3)];
            [symbolPath addCurveToPoint:CGPointMake(36, 12) controlPoint1:CGPointMake(4.6, 22) controlPoint2:CGPointMake(19.1, 9.7)];
            [symbolPath addCurveToPoint:CGPointMake(89, 14) controlPoint1:CGPointMake(59.2, 15.2) controlPoint2:CGPointMake(61.9, 31.5)];
            [symbolPath addCurveToPoint:CGPointMake(104, 15) controlPoint1:CGPointMake(95.3, 10) controlPoint2:CGPointMake(100.9, 6.9)];
            
            [symbolPath applyTransform:CGAffineTransformMakeScale(0.9524*squiggleSize.width/100, 0.9524*squiggleSize.height/50)];
            
            [symbolPath applyTransform:CGAffineTransformMakeTranslation(middle.x - symbolSize.width, middle.y - squiggleSize.height/2-voffset*self.bounds.size.height)];
        }
            break;
    }
    
    UIColor *tempColor = [UIColor blackColor];
    switch (self.color)
    {
        case 1:
            tempColor = [UIColor greenColor];
            break;
        case 2:
            tempColor = [UIColor redColor];
            break;
        default:
            tempColor = [UIColor purpleColor];
            break;
    }
    
    if ([self.shading isEqualToString:@"solid"]) {
        [tempColor setFill];
        [tempColor setStroke];
    } else if ([self.shading isEqualToString:@"striped"]) {
        //draw stripes
        [[tempColor colorWithAlphaComponent:0.6] setFill];
        [[UIColor blackColor] setStroke];
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
        [tempColor setStroke];
    }
    [symbolPath fill];
    [symbolPath stroke];
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


@end
