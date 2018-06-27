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
        
        CGPoint P1 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset) / 2) * cos((1.8*i)*(M_PI/180)+M_PI_2)), (self.frame.size.width/2 + ((self.frame.size.width - 2*2 - graduationOffset) / 2) * sin((1.8*i)*(M_PI/180)+M_PI_2)));
        int tmp = 2;
        if (i % 5 == 0) {
            tmp = 6;
        }
        CGPoint P2 = CGPointMake((self.frame.size.width/2 + ((self.frame.size.width - tmp*2 - graduationOffset - self.graduationLength) / 2) * cos((1.8*i)*(M_PI/180)+M_PI_2)), (self.frame.size.width/2 + ((self.frame.size.width - tmp*2 - graduationOffset - self.graduationLength) / 2) * sin((1.8*i)*(M_PI/180)+M_PI_2)));
        NSLog(@"x1:%f,y1:%f",P1.x,P1.y);
        NSLog(@"x2:%f,y2:%f",P2.x,P2.y);

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
    
    CGFloat markingDistanceFromCenter = rect.size.width/2.0f - digitFont.lineHeight/4.0f - 15 + digitOffset;
    
    NSInteger offset = 0;
    
//    for(int i = 0; i <= 21; i ++){
//        CGContextSaveGState(ctx);
//        NSString *hourNumber = [NSString stringWithFormat:@"%d",i];
//
//        CGFloat labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * cos((M_PI/180) * (i+offset) * 10 - M_PI - (M_PI/180)*30);
//        CGFloat labelY = center.y + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * sin((M_PI/180)*(i+offset) * 10 - (M_PI/180)*30);
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2,20,digitFont.lineHeight)];
////        if (i == 1) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 0.5,15,digitFont.lineHeight);
////        }
////        if (i == 2) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 0.5,labelY - digitFont.lineHeight/2 + 1.5,15,digitFont.lineHeight);
////        }
////        if (i == 3) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 1.5,labelY - digitFont.lineHeight/2 + 3,15,digitFont.lineHeight);
////        }
////        if (i == 4) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 3.5,labelY - digitFont.lineHeight/2 + 2.5,15,digitFont.lineHeight);
////        }
////        if (i == 5) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 5,labelY - digitFont.lineHeight/2,15,digitFont.lineHeight);
////        }
////        if (i == 6) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 4.5,labelY - digitFont.lineHeight/2,15,digitFont.lineHeight);
////        }
////        if (i == 7) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 3.5,labelY - digitFont.lineHeight/2 - 1,15,digitFont.lineHeight);
////        }
////        if (i == 8) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 1.5,labelY - digitFont.lineHeight/2 - 1,15,digitFont.lineHeight);
////        }
////        if (i == 9) {
////            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 - 0.5,15,digitFont.lineHeight);
////        }
//        label.textColor = [UIColor whiteColor];
//        label.font = digitFont;
//        label.text = hourNumber;
//        label.transform = CGAffineTransformMakeRotation(M_PI/10.5 * (i-3));
//        [self addSubview:label];
//        CGContextRestoreGState(ctx);
//    }
}




@end
