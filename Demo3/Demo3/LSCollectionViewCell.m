//
//  LSCollectionViewCell.m
//  testCollection
//
//  Created by hanya on 16/4/22.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSCollectionViewCell.h"

@implementation LSCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:label];
        
    
        self.cellLabel      = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor whiteColor];
        
    }
    return self;
}

@end
