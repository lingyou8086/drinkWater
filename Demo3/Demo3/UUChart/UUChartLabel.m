//
//  PNChartLabel.m
//  PNChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChartLabel.h"
#import "UUChartConst.h"

@implementation UUChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        
        //self.textAlignment = NSTextAlignmentLeft;
        [self setTextAlignment:NSTextAlignmentLeft];
        //[self setTextColor: [UUColor darkGrayColor]];
#pragma mark x y 轴上字的颜色
        [self setTextColor: [UUColor whiteColor]];
        
        
        [self setTextAlignment:NSTextAlignmentCenter];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
