//
//  FocusSlider.m
//  BEMAnalogClock
//
//  Created by wushuying on 2018/6/11.
//  Copyright © 2018年 Boris Emorine. All rights reserved.
//

#import "FocusSlider.h"
#import "GolbalDefine.h"

@implementation FocusSlider{
    CGFloat radius;
    int fixedAngle;
    NSMutableDictionary* labelsWithPercents;
    NSArray* labelsEvenSpacing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Defaults
        _maximumValue = 1.0f;
        _minimumValue = 0.0f;
        _currentValue = 0.0f;
        // _currentAngle =0;
        //_money= 0;
        _lineWidth = 5;
        _unfilledColor = [UIColor grayColor];
        _filledColor = [UIColor yellowColor];
        // _handleColor = _filledColor;
        _handleColor = [UIColor whiteColor];
        _labelFont = [UIFont systemFontOfSize:10.0f];
        _snapToLabels = NO;
        
        _labelColor = [UIColor redColor];
        
        _angle = 0;
        radius = self.frame.size.height/2 - _lineWidth/2 - 9;
        
        self.backgroundColor = [UIColor clearColor];
        //UIFont *font = [UIFont systemFontOfSize:10];
    }
    return self;
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI, M_PI_2 * 3 - 0.05  - ToRad(_angle), 0);//0, M_PI *2, 0
    [[UIColor whiteColor] setStroke];
    
    //    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI_2 * 3 + 0.05 - ToRad(_angle), M_PI * 2, 0);//0, M_PI *2, 0
    [[UIColor whiteColor] setStroke];
    
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //The draggable part
    [self drawHandle:ctx];
}

-(void)drawHandle:(CGContextRef)ctx{///画滑块
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: _angle];
    
    [[UIColor clearColor]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth+10, _lineWidth+10));
    //此处做了改动
    
    //     CLOCK'S BORDER
    CGContextAddEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth+10, _lineWidth+10));
    CGContextSetStrokeColorWithColor(ctx, AlertBlueColor.CGColor);
    CGContextSetAlpha(ctx, 0.5);
    CGContextSetLineWidth(ctx,1);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}



#pragma mark - UIControl functions

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, lastPoint, NO));
    int a = 360 - 90 - currentAngle;
    if (a > 60 || a < -60) {
        return YES;
    }
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    if (currentAngle > 45 && currentAngle < 135) {
        return;
    }
    _angle = 360 - 90 - currentAngle;
    
    _currentValue = [self valueFromAngle];
    //  NSLog(@"%f",_currentValue);
    
    _value=_angle;
    
    [self setNeedsDisplay];
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    //    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2 - 5, self.frame.size.height/2 - _lineWidth/2 - 5);
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt-90)));
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt-90)));
    return result;
}

- (void)autoAdjustWithAngle:(int)angleInt{
    CGPoint point = [self pointFromAngle:angleInt];
    [self moveHandle:point];
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    //    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    //    v.x /= vmag;
    //    v.y /= vmag;
    float result = 0 ;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}


-(float)valueFromAngle {
    if(_angle < 0) {
        _currentValue = -_angle;
    } else {
        _currentValue = 270 - _angle + 90;
    }
    fixedAngle = _currentValue;
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
}

- (CGFloat) widthOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setInnerMarkingLabels:(NSArray*)labels{
    labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}

@end
