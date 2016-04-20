//
//  LSInputView.h
//  Demo3
//
//  Created by hanya on 16/4/2.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import <UIKit/UIKit.h>
#define mDevice  ([[[UIDevice currentDevice] systemVersion] floatValue])

@protocol LSInputViewDelegate <NSObject>

@optional
- (void)inputViewDelegate ;


@end

@interface LSInputView : UIView

@property (nonatomic, assign) id <LSInputViewDelegate> delegate;

@property (nonatomic, strong) UITextField *inputfeild;
@property (nonatomic, strong) UILabel *unit;



- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;

@end
