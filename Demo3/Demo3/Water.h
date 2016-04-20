//
//  Water.h
//  Water
//
//  Created by Stephen on 15/11/2.
//  Copyright © 2015年 Stephen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface Water : UIView
@property (strong,nonatomic) CMMotionManager *manager;


@property (nonatomic,assign) NSInteger height ;


@end
