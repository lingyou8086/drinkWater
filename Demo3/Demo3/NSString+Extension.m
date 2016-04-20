//
//  NSString+Extension.m
//  12.QQ
//
//  Created by hanya on 16/3/24.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)textSizewithFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    
    NSDictionary * attr = @{NSFontAttributeName : font};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}


@end
