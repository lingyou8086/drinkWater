//
//  UUBar.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBar.h"
#import "UUChartConst.h"

@implementation UUBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapSquare;
		_chartLine.fillColor = [UIColor whiteColor].CGColor;
		_chartLine.lineWidth = self.frame.size.width;
		_chartLine.strokeEnd = 0.0;
        [self.layer addSublayer:_chartLine];
		self.clipsToBounds = YES;
        self.layer.cornerRadius = 2.0;
        
        
    }
    return self;
}

-(void)setGradePercent:(float)gradePercent
{
    if (gradePercent==0)
    return;
    
	_gradePercent = gradePercent;
	UIBezierPath *progressline = [UIBezierPath bezierPath];
    
#pragma mark 调整绘图的线条
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0 -9, self.frame.size.height+30)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0 -9 , (1 - gradePercent) * self.frame.size.height+15)];
    [progressline setLineWidth:1];
    [progressline setLineCapStyle:kCGLineCapSquare];
	_chartLine.path = progressline.CGPath;
    _chartLine.strokeColor = _barColor.CGColor ?: [UUColor green].CGColor;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0;
    pathAnimation.toValue = @1.0;
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 2.0;
}

- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#pragma mark 柱状图的背景颜色
    //CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0].CGColor);
    
	CGContextFillRect(context, rect);
}


@end
