//
//  LSSetingTableViewController.m
//  Demo3
//
//  Created by hanya on 16/4/12.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSSetingTableViewController.h"
#import "FMDatabase.h"

#import "Masonry.h"
#import "SVProgressHUD.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define mDevice  ([[[UIDevice currentDevice] systemVersion] floatValue])


@interface LSSetingTableViewController ()<UITextFieldDelegate>

- (IBAction)didClickClose:(UIBarButtonItem *)sender;

// 起床时间
@property (weak, nonatomic) IBOutlet UITextField *getupTimeLabel;
//休息时间
@property (weak, nonatomic) IBOutlet UITextField *sleepTimeLabel;
// 体重
@property (weak, nonatomic) IBOutlet UITextField *weight;
// 每次饮水量
@property (weak, nonatomic) IBOutlet UITextField *waterIntakeLabel;

@property (nonatomic, copy) NSString *oldGetUpTime;
@property (nonatomic, copy) NSString *oldSleepTime;
@property (weak, nonatomic) IBOutlet UISwitch *notifiSwitch;

- (IBAction)notificationSwitch:(UISwitch *)sender;

@property (nonatomic, strong) FMDatabase *database;


@property (nonatomic, weak) UIDatePicker *picker1;
@property (nonatomic, weak) UIDatePicker *picker2;

@end

@implementation LSSetingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL swithState = [defaults floatForKey:@"swithState"];
    self.notifiSwitch.on = swithState;
    
    // 设置标题颜色为白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.getupTimeLabel.textColor    = [UIColor blackColor];
    UIDatePicker * picker1           = [self getPicker];
    self.getupTimeLabel.inputView    = picker1;
    self.picker1                     = picker1;
    self.getupTimeLabel.inputAccessoryView = [self getToolBarWithType:@"time1"];
    
    
    self.sleepTimeLabel.textColor    = [UIColor blackColor];
    UIDatePicker * picker2           = [self getPicker];
    self.sleepTimeLabel.inputView    = picker2;
    self.picker2                     = picker2;
    self.sleepTimeLabel.inputAccessoryView = [self getToolBarWithType:@"time2"];
    
    self.weight.textColor            = [UIColor blackColor];
    self.weight.inputAccessoryView = [self getToolBarWithType:@""];
    self.weight.keyboardType       = UIKeyboardTypeNumberPad;
    
    self.waterIntakeLabel.textColor  = [UIColor blackColor];
    self.waterIntakeLabel.inputAccessoryView = [self getToolBarWithType:@"intake"];
    self.waterIntakeLabel.keyboardType       = UIKeyboardTypeNumberPad;

    
    // 创建/读取本地数据库
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];
    self.database             = database;
    BOOL success              =  [database open];
    if (success) {
        
        
        NSString * sql           = @"SELECT getupStr, sleepStr,weightStr,waterIntakeStr  FROM t_firstSeting ;";
        FMResultSet *result      = [self.database executeQuery:sql];
        while ([result next]) {
            
            self.getupTimeLabel.text    = [result stringForColumnIndex:0];
            self.oldGetUpTime           = self.getupTimeLabel.text;
            self.sleepTimeLabel.text    = [result stringForColumnIndex:1];
            self.oldSleepTime           = self.sleepTimeLabel.text;
            self.weight.text            = [result stringForColumnIndex:2];
            self.waterIntakeLabel.text  = [result stringForColumnIndex:3];

        }

    }else{
        
        NSLog(@"数据库打开失败");
    }
    
    
}


// UITextFeild 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    // 禁止点击其他cell
    self.tableView.userInteractionEnabled = NO;
    
    textField.text = @"";
    return YES;
}

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


// 点击工具条上的完成
- (void)didClickDone:(UIBarButtonItem *)item {
    
    
    if (item.tag == 0 || item.tag == 1) {
        // 取出选择的时间
        NSDate * date;
        if (item.tag == 0) {
             date                   = self.picker1.date;
        }else {
             date                   = self.picker2.date;
        }
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat        = @"HH:mm";
        NSString * dateStr              = [dateFormatter stringFromDate:date];
        
        // 对时间进行检验
        
        if (item.tag == 0) {
            
            int moningDead              = 12;
            int  subStr                 = [[dateStr substringToIndex:2] intValue];
            
            if ( moningDead > subStr) {
                
                self.getupTimeLabel.text            = dateStr;
                
            }else {
                [SVProgressHUD showErrorWithStatus:@"请正确选择时间"];
                self.getupTimeLabel.text    = @"07:00";
                return;
            }
        }else {
            
            int  nightDead              = 24;
            int  subStr                 = [[dateStr substringToIndex:2] intValue];
            
            if ( nightDead > subStr && subStr >=12) {
                
                self.sleepTimeLabel.text = dateStr;
                
            }else {
                [SVProgressHUD showErrorWithStatus:@"请正确选择时间"];
                self.sleepTimeLabel.text = @"23:00";
                return;
            }
        }
    }else {
        
        if (item.tag == 2) {
            
            int inputNum                 = [self.weight.text intValue];
            if (!(inputNum > 0 && inputNum < 200 )) {
                
                [SVProgressHUD showErrorWithStatus:@"请输入正确的体重"];
                self.weight.text    = @"";
                return;
            }
        }else {
            
            int inputNum                = [self.waterIntakeLabel.text intValue];
            
            if (!(inputNum > 0 && inputNum <= 500 )) {
                
                [SVProgressHUD showErrorWithStatus:@"请输入正确的数值(0-500),建议300"];
                self.waterIntakeLabel.text    = @"";
                return;
            }
            
        }

    }
    
    [self.view endEditing:YES];
    
    //打开tableView的交互
    self.tableView.userInteractionEnabled = YES;
    
    

    
}


#pragma mark 点击关闭
- (IBAction)didClickClose:(UIBarButtonItem *)sender {
    
    if (![self.oldSleepTime isEqualToString:self.sleepTimeLabel.text] || ![self.oldGetUpTime isEqualToString:self.getupTimeLabel.text]) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self addLocalNotification];
    }
    
    // 向数据库更新数据
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE t_firstSeting SET getupStr='%@', sleepStr='%@',weightStr='%@',waterIntakeStr='%@';",self.getupTimeLabel.text,self.sleepTimeLabel.text,self.weight.text,self.waterIntakeLabel.text];
    
    NSLog(@"----%@-----",self.weight.text);
    
    BOOL success = [self.database executeUpdate:sql];
    
    if (success) {
        NSLog(@"设置数据更新成功");
    } else {
        NSLog(@"设置数据更新失败");
    }
    
    
    ///////////////////////发出通知,更新主界面label的值////////////////////////
    ///主界面收到通知后刷新喝水进度,并且判断 底部button的交互是否打开  并且要更改 设定的喝水通知的时间 等
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter] ;
    [center postNotificationName:@"settingNotification" object:self userInfo:nil];
    
    ///////////////////////////////////////////////////////////////////////
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



// 打开或关闭喝水的本地通知
- (IBAction)notificationSwitch:(UISwitch *)sender {
    
    if (sender.isOn) {
        // 重新添加本地通知
        [self addLocalNotification];
        
        NSArray * localNotiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for (UILocalNotification * local in localNotiArray) {
            NSLog(@"%@",local);
        }
        
    }
    else {
        // 清除本地通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"swithState"];
}


#pragma mark 添加本地通知
- (void)addLocalNotification{

    if (mDevice >= 8.0) {
        UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)  categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    
    NSArray * moning = [self.getupTimeLabel.text componentsSeparatedByString:@":"];
    
    int moningHour = [moning[0] intValue];
    int moningMinute = [moning[1] intValue];
    
    NSArray * night = [self.sleepTimeLabel.text componentsSeparatedByString:@":"];
    
    int nightHour = [night[0] intValue];
    int nightMinute = [night[1] intValue];
    
    UILocalNotification *notification1=[[UILocalNotification alloc] init];
    NSDate * date ;
    //判断第一个闹钟是否在早8点之前
    if ((moningHour - 8)<0 & moningMinute > 0) {
        date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 +1)*60*60-moningMinute*60];//本次开启立即执行的周期
    } else if((moningHour - 8)<0 & moningMinute == 0){
        date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
    }else
        date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
    
    notification1.fireDate = [NSDate dateWithTimeInterval:5*60 sinceDate:date];
    
    [self addAlarmNotification:notification1];
    
    UILocalNotification *notification2=[[UILocalNotification alloc] init];
    notification2.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification1.fireDate];
    [self addAlarmNotification:notification2];
    
    UILocalNotification *notification3=[[UILocalNotification alloc] init];
    notification3.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification2.fireDate];
    [self addAlarmNotification:notification3];
    
    UILocalNotification *notification4=[[UILocalNotification alloc] init];
    notification4.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification3.fireDate];
    [self addAlarmNotification:notification4];
    
    UILocalNotification *notification5=[[UILocalNotification alloc] init];
    notification5.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification4.fireDate];
    [self addAlarmNotification:notification5];
    
    
    UILocalNotification *notification6=[[UILocalNotification alloc] init];
    notification6.fireDate = [NSDate dateWithTimeIntervalSince1970:(nightHour -9)*60*60+nightMinute*60];
    [self addAlarmNotification:notification6];

}

#pragma mark 抽出添加闹钟的方法
- (void)addAlarmNotification:(UILocalNotification *)localNoti {
    
    localNoti.repeatInterval=kCFCalendarUnitDay;//循环通知的周期 每天
    localNoti.timeZone=[NSTimeZone defaultTimeZone];
    localNoti.alertBody=@"该喝水了";//弹出的提示信息
    localNoti.applicationIconBadgeNumber +=1 ; //应用程序的右上角小数字
    localNoti.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
    //notification.alertAction = NSLocalizedString(@"", nil);  //弹出的提示框按钮
    localNoti.hasAction = NO;
    [[UIApplication sharedApplication]   scheduleLocalNotification:localNoti];
}


- (BOOL)prefersStatusBarHidden {

    return YES;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
@end
