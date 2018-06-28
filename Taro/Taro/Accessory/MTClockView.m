//
//  MTClockView.m
//  BEMAnalogClock
//
//  Created by wushuying on 2018/6/5.
//  Copyright © 2018年 Boris Emorine. All rights reserved.
//

#import "MTClockView.h"

@implementation MTClockView{
    NSArray *dataArray;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 60;
        self.backgroundColor = [UIColor clearColor];
        dataArray = @[@"1000",@"997",@"975",@"904",@"755",@"600",@"553",@"364",@"227",@"140",@"88",@"56",@"37",@"25",@"18",@"13",@"9.1",@"6.7",@"5.1",@"3.9",@"3.0"];
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
    for (int i = 0; i<101; i++) {
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
    
    for(int i = 0; i < 21; i ++){
        CGContextSaveGState(ctx);
        NSString *hourNumber = [NSString stringWithFormat:@"1/%@ s",dataArray[i]];

        CGFloat labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * cos((M_PI/180) * (i+offset) * 9 + M_PI_2);
        CGFloat labelY = center.y + (markingDistanceFromCenter - digitFont.lineHeight/2.0f) * sin((M_PI/180)*(i+offset) * 9 + M_PI_2);

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2,80,digitFont.lineHeight)];
        if (i >=9 && i <= 10) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 1,40,digitFont.lineHeight);
        }
        if (i == 11) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 3,40,digitFont.lineHeight);
        }
        if (i == 12) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 4,40,digitFont.lineHeight);
        }
        if (i == 13) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 5,40,digitFont.lineHeight);
        }
        if (i == 14) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 8,40,digitFont.lineHeight);
        }
        if (i == 15) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 10,40,digitFont.lineHeight);
        }
        if (i == 16) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2,labelY - digitFont.lineHeight/2 + 10,40,digitFont.lineHeight);
        }

        if (i == 17) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 3,labelY - digitFont.lineHeight/2 + 13,40,digitFont.lineHeight);
        }

        if (i == 18) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 5,labelY - digitFont.lineHeight/2 + 14,40,digitFont.lineHeight);
        }

        if (i == 19) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 5,labelY - digitFont.lineHeight/2 + 14,40,digitFont.lineHeight);
        }

        if (i == 20) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 8,labelY - digitFont.lineHeight/2 + 14,40,digitFont.lineHeight);
        }

        if (i == 7) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 + 1,labelY - digitFont.lineHeight/2 + 1 - 5,40,digitFont.lineHeight);
        }
        if (i == 8) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 + 1,labelY - digitFont.lineHeight/2 + 1 - 3,40,digitFont.lineHeight);
        }
        if (i == 4) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 3,labelY - digitFont.lineHeight/2 - 1 - 10,40,digitFont.lineHeight);
        }
        if (i == 5) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 1,labelY - digitFont.lineHeight/2 - 1 - 6,40,digitFont.lineHeight);
        }
        if (i == 6) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 1,labelY - digitFont.lineHeight/2 - 1 - 4,40,digitFont.lineHeight);
        }
        if (i == 2) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 6,labelY - digitFont.lineHeight/2 - 3 - 10,40,digitFont.lineHeight);
        }
        if (i == 3) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 4,labelY - digitFont.lineHeight/2 - 3 - 10,40,digitFont.lineHeight);
        }
        if (i == 0) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 10,labelY - digitFont.lineHeight/2 - 4 - 10,40,digitFont.lineHeight);
        }
        if (i == 1) {
            label.frame = CGRectMake(labelX - digitFont.lineHeight/2 - 8,labelY - digitFont.lineHeight/2 - 4 - 10,40,digitFont.lineHeight);
        }
        label.textColor = [UIColor whiteColor];
        label.font = digitFont;
        label.text = hourNumber;
//        label.backgroundColor = [UIColor redColor];
        label.layer.anchorPoint = CGPointMake(0.5,cos((M_PI_2/20)*i));
////        label.transform = CGAffineTransformMakeRotation(-M_PI_2 + (M_PI/20)*i);
        label.transform = CGAffineTransformMakeRotation(-M_PI_2 + (M_PI/20)*i);
        [self addSubview:label];
        CGContextRestoreGState(ctx);
    }
}




@end
