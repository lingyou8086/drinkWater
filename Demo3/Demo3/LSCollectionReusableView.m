//
//  LSCollectionReusableView.m
//  testCollection
//
//  Created by hanya on 16/4/22.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSCollectionReusableView.h"



@implementation LSCollectionReusableView



- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"LSCollectionReusableView" owner:self options:nil] lastObject];
        
       
    }

    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
