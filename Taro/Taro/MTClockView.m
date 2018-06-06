//
//  MTClockView.m
//  BEMAnalogClock
//
//  Created by wushuying on 2018/6/5.
//  Copyright © 2018年 Boris Emorine. All rights reserved.
//

#import "MTClockView.h"

@implementation MTClockView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 60;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Drawings

- (void)drawRect:(CGRect)rect {
    // CLOCK'S FACE
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetAlpha(ctx, 0.5);
    CGContextFillPath(ctx);
    
//     CLOCK'S BORDER
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.origin.x + self.borderWidth/2, rect.origin.y + self.borderWidth/2, rect.size.width - self.borderWidth, rect.size.height - self.borderWidth));
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetAlpha(ctx, 0.5);
    CGContextSetLineWidth(ctx,self.borderWidth);
    CGContextStrokePath(ctx);

    // CLOCK'S GRADUATION
    for (int i = 0; i<100; i++) {
        self.graduationLength = 10;
        
        CGFloat graduationOffset = 10;
        
        CGPoint P1 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset) / 2) * cos((3.6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset) / 2) * sin((3.6*i)*(M_PI/180)  - (M_PI/2))));
        
        CGPoint P2 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset - self.graduationLength) / 2) * cos((3.6*i)*(M_PI/180)  - (M_PI/2))), (self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset - self.graduationLength) / 2) * sin((3.6*i)*(M_PI/180)  - (M_PI/2))));
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        shapeLayer.path = path1.CGPath;
        [path1 setLineWidth:1.0];
        [path1 moveToPoint:P1];
        [path1 addLineToPoint:P2];
        path1.lineCapStyle = kCGLineCapSquare;
        [[UIColor whiteColor] set];
        
        [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    }
    
    // DIGIT DRAWING
    
    UIFont *digitFont = [UIFont systemFontOfSize:9];
    CGFloat digitOffset = 0;
    
    CGPoint center = CGPointMake(rect.size.width/2.0f, rect.size.height/2.0f);
    NSLog(@"centerX:%f\n",center.x);
    CGFloat markingDistanceFromCenter = rect.size.width/2.0f - digitFont.lineHeight/4.0f - 15 + digitOffset;
    NSLog(@"markingDistanceFromCenter:%f\n",markingDistanceFromCenter);
    NSInteger offset = 4;
    
    for(int i = 0; i < 10; i ++){
        NSString *hourNumber = [NSString stringWithFormat:@"0.%d",i-6];
        if (i < 6) {
            hourNumber = [NSString stringWithFormat:@"0.%d",i+4];
        }

        
        CGFloat labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * cos((M_PI/180) * (i+offset) * 36 - M_PI);
        CGFloat labelY = center.y + - 1 * (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * sin((M_PI/180)*(i+offset) * 36);
        
        [hourNumber drawInRect:CGRectMake(labelX - digitFont.lineHeight/2.0f,labelY - digitFont.lineHeight/2.0f,30,digitFont.lineHeight) withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: digitFont}];
        
        NSLog(@"x:%f\ny:%f",labelX,labelY);
    }
}




@end
