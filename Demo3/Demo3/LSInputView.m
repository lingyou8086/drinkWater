//
//  LSInputView.m
//  Demo3
//
//  Created by hanya on 16/4/2.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSInputView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"

#define kScreenSize [UIScreen mainScreen].bounds.size



@interface LSInputView ()<UITextFieldDelegate>

// 时间选择器
@property (nonatomic,weak) UIDatePicker * picker;
// 工具条
@property (nonatomic,weak) UIToolbar    * toolBar;



@end

@implementation LSInputView

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type{

    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.inputfeild               = [[UITextField alloc] init];
        [self addSubview:self.inputfeild];
        
        self.unit                     = [[UILabel alloc] init];
        [self addSubview:self.unit];
        
        // 设置预设值
        self.inputfeild.text          = @"07:00";
        self.unit.text                = @"AM";
        
        // 设置文字属性
        self.inputfeild.textColor     = [UIColor colorWithRed:53/255.0 green:167/255.0 blue:240/255.0 alpha:1] ;
//        self.inputfeild.font          = [UIFont systemFontOfSize:36];
        if (mDevice < 8.0) {
            self.inputfeild.font          = [UIFont systemFontOfSize:28.8];
            self.unit.font                = [UIFont systemFontOfSize:28.8];
        }else {
            self.inputfeild.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:36];
            self.unit.font                = [UIFont fontWithName:@"PingFangSC-Thin" size:36];
        }
        
        self.inputfeild.textAlignment = NSTextAlignmentRight;
        
        
        self.unit.textColor           = [UIColor colorWithRed:53/255.0 green:167/255.0 blue:240/255.0 alpha:1] ;
        
        UIToolbar * toolBar           = [self getToolBarWithType:type];
        self.toolBar                  = toolBar;
        
        // 根据要输入的数据类型设置键盘类型
        if ([type isEqualToString:@"time1"] || [type isEqualToString:@"time2"]) {
            
            UIDatePicker * picker    = [self getPicker];
            self.picker              = picker;
            
            self.inputfeild.inputView          = picker;
            self.inputfeild.inputAccessoryView = toolBar;
        }else {
            self.inputfeild.keyboardType       = UIKeyboardTypeNumberPad;
            self.inputfeild.textAlignment      = NSTextAlignmentRight;
            self.inputfeild.text               = @"50";
            self.inputfeild.inputAccessoryView = toolBar;
            self.inputfeild.delegate           = self;
            self.unit.text                     = @"KG";
            // 区分键盘,最后一个要使view上升
            if ([type isEqualToString:@"special"]) {
                self.inputfeild.tag            = 1;
                self.inputfeild.text               = @"300";
                self.unit.text                     = @"ML";
            }
        }
        
    }
    
    return self;
}

// UITextFeild 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    textField.text = @"";
    return YES;
}
//// 输入结束
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//    NSLog(@"输入结束");
//}

// 获取pickerView
- (UIDatePicker *)getPicker {

    UIDatePicker * picker  = [[UIDatePicker alloc] init];
    
    picker.datePickerMode  = UIDatePickerModeTime;
    picker.backgroundColor = [UIColor whiteColor];
    
    return picker;
}


// 键盘上的工具条
- (UIToolbar *)getToolBarWithType:(NSString *)type{

    UIToolbar * toolBar      = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    //[toolBar setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem * spring = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * done   = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone:)];
    done.tintColor           = [UIColor blackColor];
    
    toolBar.items            = @[spring,done];
    
    if ([type isEqualToString:@"time1" ]) {
        done.tag                 = 0;
    }else if([type isEqualToString:@"time2"]){
        done.tag                 = 1;
    }else if([type isEqualToString:@""]){
        done.tag                 = 2;
    }else {
        done.tag                 = 3;
    }
    
    return toolBar;
}


// 点击完成
- (void)didClickDone:(UIBarButtonItem *)item {


    if (item.tag == 0 || item.tag == 1) {
        // 取出选择的时间
        NSDate * date                   = self.picker.date;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat        = @"HH:mm";
        NSString * dateStr              = [dateFormatter stringFromDate:date];
        
        // 对时间进行检验

        if (item.tag == 0) {
            
            int moningDead              = 12;
            int  subStr                 = [[dateStr substringToIndex:2] intValue];
        
            if ( moningDead > subStr) {
                NSLog(@"isRight!");

            }else {
                [SVProgressHUD showErrorWithStatus:@"请正确选择时间"];
                self.inputfeild.text    = @"07:00";
                return;
            }
        }else {
            
            int  nightDead              = 24;
            int  subStr                 = [[dateStr substringToIndex:2] intValue];
            
            if ( nightDead > subStr && subStr >=12) {
                NSLog(@"isRight!");
                
            }else {
                [SVProgressHUD showErrorWithStatus:@"请正确选择时间"];
                self.inputfeild.text    = @"11:00";
                return;
            }
        }
        
        self.inputfeild.text            = dateStr;
        
        if ([self.delegate respondsToSelector:@selector(inputViewDelegate)]) {
            [self.delegate inputViewDelegate];
        }
    }else {
    
        if (item.tag == 2) {
            
            int inputNum                = [self.inputfeild.text intValue];
            
            if (!(inputNum > 0 && inputNum < 200 )) {
                
                [SVProgressHUD showErrorWithStatus:@"请输入正确的体重"];
                self.inputfeild.text    = @"";
                return;
            }
        }else {
            
            int inputNum                = [self.inputfeild.text intValue];
            
            if (!(inputNum > 0 && inputNum <= 500 )) {
                
                [SVProgressHUD showErrorWithStatus:@"请输入正确的数值(0-500),建议300"];
                self.inputfeild.text    = @"";
                return;
            }

        }
        
        if ([self.delegate respondsToSelector:@selector(inputViewDelegate)]) {
            [self.delegate inputViewDelegate];
        }
    }


}


- (void)layoutSubviews {

    
    
    [self.unit mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.equalTo(self);
    }];
    [self.inputfeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self.unit.mas_left);
    }];
    
    // 这句话在4S上放到最后才可以运行
    [super layoutSubviews];
    

    
}

@end
