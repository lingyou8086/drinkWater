//
//  Water.m
//  Water
//
//  Created by Stephen on 15/11/2.
//  Copyright © 2015年 Stephen. All rights reserved.
//

#import "Water.h"
#import "UIColor+Hex.h"

#define mDevice  ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface Water ()
{
    UIColor *_color;
    float _pointY;
    float b;
}
@end
@implementation Water

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#1E384C"];
        b = 0;
        _color = [UIColor colorWithHexString:@"#32BAFA"];
        
        // 控制水位高度
        if (mDevice < 8.0) {
            _pointY = 80;
        } else {
            _pointY = 200;
        }
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(waterWare) userInfo:nil repeats:YES];
        
    }
    return self;
}



- (void)setHeight:(NSInteger)height {


    _height = height;
    NSLog(@"--------%zd---------",height);
    
//    if (height > 1) {
//        
//        _pointY += ([UIScreen mainScreen].bounds.size.height - 200) / 6 ;
//
//    }else {
//        _pointY = [UIScreen mainScreen].bounds.size.height;
//    }
    
    _pointY = height;
    
    NSLog(@"_pointY:%f",_pointY);
    
    }





- (void)waterWare{
    b += 0.3;
    [self setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect{
    // 获取视图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 可变路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 填充颜色
    CGContextSetFillColorWithColor(context, [_color CGColor]);
    float y = 0;
    CGPathMoveToPoint(path, nil, 0, 0);
    
    for (float x = 0; x < self.frame.size.width; x++) {
        y = sin(x / 180 * M_PI + 4 * b / M_PI) * 6.5 + _pointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    // 添加点
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _pointY);
    
    CGContextAddPath(context, path); // 上下文
    CGContextFillPath(context); // 填充路径
    CGContextDrawPath(context, kCGPathStroke); // 绘制路径
    CGPathRelease(path);
    
    
}
@end



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

