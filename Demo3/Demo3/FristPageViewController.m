//
//  FristPageViewController.m
//  Demo3
//
//  Created by hanya on 16/3/31.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "FristPageViewController.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import "LSMainViewController.h"
#import "LSInputView.h"
#import "LSInputView.h"
#import <sqlite3.h>
#import "FMDatabase.h"

#import <sys/utsname.h>





#define kScreenSize [UIScreen mainScreen].bounds.size

@interface FristPageViewController ()<UITextFieldDelegate,LSInputViewDelegate>

// hello label
@property (nonatomic, weak) UILabel *helloLabel;
// 提醒填写信心 label
@property (nonatomic, weak) UILabel *tipsLabel;
// 起床时间 label
@property (nonatomic, weak) UILabel *getUpTime;
// 设定起床时间
@property (nonatomic, weak) LSInputView *getUpTimeView;
// 休息时间Label
@property (nonatomic, weak) UILabel *sleepTime;
// 设定休息时间
@property (nonatomic, weak) LSInputView *sleepView;
// 体重Label
@property (nonatomic, weak) UILabel *weightLabel;
// 设定体重
@property (nonatomic, weak) LSInputView *weightView;
// 饮水量Label
@property (nonatomic, weak) UILabel *waterIntake;
// 设置饮水量
@property (nonatomic, weak) LSInputView *waterView;
// 数据库
@property (nonatomic, strong) FMDatabase *database;
// 数据库打开状态
@property (nonatomic, assign) BOOL success;
/*
 NSString *getupStr         = @"";
 //休息时间
 NSString *sleepStr         = @"";;
 //体重
 NSString *weightStr        = @"";;
 //饮水量
 NSString *waterIntakeStr   = @"";;
 */

@property (nonatomic, copy) NSString *getupStr ;
@property (nonatomic, copy) NSString *sleepStr;
@property (nonatomic, copy) NSString *weightStr;
@property (nonatomic, copy) NSString *waterIntakeStr;



@end

@implementation FristPageViewController

/*
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] );
    
    self.view.backgroundColor = [UIColor colorWithRed:44/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
    
    //NSLog(@"mDevice:%f",mDevice);
    //NSString *deviceStr = [self deviceString];
   // NSLog(@"deviceStr:%@",deviceStr);
    
    
    // 创建/读取本地数据库
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];
    self.database             = database;
    BOOL success              =  [database open];
    self.success              =success;
    if (success) {
        NSLog(@"FristPageViewController创建/打开数据库成功!");
        //创建表  id  getupTime	sleepTime	weight	waterIntake
        
        BOOL successT1         =  [self.database executeUpdate:@"CREATE   TABLE IF NOT EXISTS t_firstSeting(id INTEGER PRIMARY KEY AUTOINCREMENT ,getupStr TEXT  , sleepStr TEXT ,weightStr TEXT,waterIntakeStr TEXT);"];
        if (successT1) {
            NSLog(@"FristPageViewController创建表:t_firstSeting成功!");
            
            // 插入一条初始化数据  INSERT INTO state(state) VALUES (5);
            BOOL successT1_1  =  [self.database executeUpdate:@"INSERT INTO t_firstSeting(getupStr, sleepStr,weightStr,waterIntakeStr) VALUES ('07:00','23:00','50','300');"];
            
            if (successT1_1) {
                NSLog(@"FristPageViewController向表:t_firstSeting插入预设数据成功!");
            } else {
                NSLog(@"FristPageViewController向表:t_firstSeting插入预设数据失败!");

            }
            
        }else{
            NSLog(@"FristPageViewController创建表:t_firstSeting失败!!");
        }
        
        //创建表  t_mainSeting   id	setButtonState	progress  lastTime
        
        BOOL successT2         =  [self.database executeUpdate:@"CREATE   TABLE IF NOT EXISTS t_mainSeting(id INTEGER PRIMARY KEY AUTOINCREMENT ,setButtonState INTEGER,progress TEXT,lastTime TEXT);"];
        if (successT2) {
            NSLog(@"FristPageViewController创建表:t_mainSeting成功!");
            
            [self.database executeUpdate:@"DELETE FROM t_mainSeting ;"];
            
            // 插入一条初始化数据
            BOOL successT2_1  =  [self.database executeUpdate:@"INSERT INTO t_mainSeting(setButtonState,progress,lastTime) VALUES (0,'0','00:00')"];
            
            if (successT2_1) {
                NSLog(@"FristPageViewController向表:t_mainSeting插入预设数据成功!");
            } else {
                NSLog(@"FristPageViewController向表:t_mainSeting插入预设数据失败!");
            }
        }else{
            NSLog(@"FristPageViewController创建表:t_mainSeting失败!!");
        }

        // 创建表3 存储日期和喝水量   t_record    id  time  volume  fullTime
        
        BOOL successT3         =  [self.database executeUpdate:@"CREATE   TABLE IF NOT EXISTS t_record(id INTEGER PRIMARY KEY AUTOINCREMENT ,time TEXT,volume INTEGER, total INTEGER,fullTime TEXT);"];
        if (successT3) {
            NSLog(@"FristPageViewController创建表:t_record成功!");
            
            [self.database executeUpdate:@"DELETE FROM t_record ;"];
            
            // 插入一条初始化数据
            BOOL successT3_1  =  [self.database executeUpdate:@"INSERT INTO t_record(time,volume,total) VALUES ('0',0,0,'2016:04:19')"];
            
            if (successT3_1) {
                NSLog(@"FristPageViewController向表:t_record插入预设数据成功!");
            } else {
                NSLog(@"FristPageViewController向表:t_record插入预设数据失败!");
            }
        }else{
            NSLog(@"FristPageViewController创建表:t_record失败!!");
        }
 
    }else{
        NSLog(@"FristPageViewController创建数据库失败!");
    }
    
    // 查询数据库
    
        //起床时间
    self.getupStr            = @"";
        //休息时间
    self.sleepStr            = @"";;
        //体重
    self.weightStr           = @"";;
        //饮水量
    self.waterIntakeStr      = @"";;
    
    // 查询定制的数据
    [self selectWithState:success];
    
#pragma mark 注册对键盘监听的通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //添加子控件
    
        // 你好
    UILabel * helloLabel     = [[UILabel alloc] init];
    self.helloLabel          = helloLabel;
    //helloLabel.backgroundColor = [UIColor orangeColor];
    helloLabel.text          = @"你好";
    helloLabel.textAlignment = NSTextAlignmentCenter;
    
    if (mDevice < 8.0) {
        helloLabel.font          = [UIFont systemFontOfSize:28.8];
        //helloLabel.font          = [UIFont fontWithName:@"PingFangSC-Ultralight" size:28.8];
    } else {
        helloLabel.font          = [UIFont fontWithName:@"PingFangSC-Ultralight" size:36];
    }
    
    helloLabel.textColor     = [UIColor whiteColor];
    [self.view addSubview:helloLabel];
    
    [helloLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        if (mDevice < 8.0) {
            
            make.left.equalTo(self.view).offset(131.5);
            make.top.equalTo(self.view).offset(41);
            //        make.width.equalTo(@72);
            //        make.height.equalTo(@50);
            make.size.mas_equalTo(CGSizeMake(58, 40.5));
        } else {
            
            make.left.equalTo(self.view).offset(152);
            make.top.equalTo(self.view).offset(55);
            //        make.width.equalTo(@72);
            //        make.height.equalTo(@50);
            make.size.mas_equalTo(CGSizeMake(72, 50));
        }
        
    }];

    // 输出系统支持的字体
//    for(NSString *familyName in [UIFont familyNames])
//    {
//        NSLog(@"familyName = %@", familyName);
//        
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
//        {
//            NSLog(@"\tfontName = %@", fontName);
//        }
//    }
    
    
        // 开始之前,请填选你的信息来生成合理的饮水计划
    UILabel * tipsLabel     = [[UILabel alloc] init];
    self.tipsLabel          = tipsLabel;
    //tipsLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tipsLabel];
    
    tipsLabel.text          = @"开始之前,请填选你的信息来生成合理的饮水计划";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor     = [UIColor colorWithRed:123/255.0 green:127/255.0 blue:131/255.0 alpha:1.0];
    if (mDevice < 8.0) {
        tipsLabel.font          = [UIFont systemFontOfSize:11.2];
        //tipsLabel.font          = [UIFont fontWithName:@"PingFangSC-Light" size:11.2];
    } else {
        
        tipsLabel.font          = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (mDevice < 8.0) {
            
            make.top.equalTo(helloLabel.mas_bottom).offset(9);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@16);
        } else {
            
            make.top.equalTo(helloLabel.mas_bottom).offset(11.5);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@20);
        }
    }];
    
        // 你的起床时间
    UILabel * getUpTime     = [[UILabel alloc] init];
    self.getUpTime          = getUpTime;
    [self.view addSubview:getUpTime];
    
    getUpTime.textColor     = [UIColor whiteColor];
    getUpTime.text          = @"你的起床时间";
    getUpTime.textAlignment = NSTextAlignmentCenter;
    if (mDevice < 8.0) {
        getUpTime.font          = [UIFont systemFontOfSize:14.4];
        //getUpTime.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:14.4];
        
    } else {

        getUpTime.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:18];
    }

    [getUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (mDevice < 8.0) {
            
            make.top.equalTo(tipsLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@20.5);
            
        } else {
            
            make.top.equalTo(tipsLabel.mas_bottom).offset(25.5);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@25);
        }

    }];

    // 设定起床时间
    CGRect getupRect;
    if (mDevice < 8.0) {
        
        getupRect = CGRectMake(0, 0, 117.5, 40.5);
    } else {

        getupRect = CGRectMake(0, 0, 147, 50);
        
    }
    
    LSInputView * getUpTimeView = [[LSInputView alloc] initWithFrame:getupRect withType:@"time1"];
    
    getUpTimeView.delegate      = self;
    
    // 通过查询数据库结果设定起床时间
    [self setDataUseSelectResultWith:getUpTimeView andResultString:self.getupStr andString:@"07:00"];
    
    self.getUpTimeView          = getUpTimeView;
    [self.view addSubview:getUpTimeView];
    
    [getUpTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (mDevice < 8.0) {
            
            make.top.equalTo(getUpTime.mas_bottom).offset(4.5);
        } else {
            
            make.top.equalTo(getUpTime.mas_bottom).offset(6);
            
        }
        make.centerX.equalTo(self.view);
    }];
    
    
        // 你的休息时间
    UILabel * sleepTime     = [[UILabel alloc] init];
    self.sleepTime          = sleepTime;
    [self.view addSubview:sleepTime];
    sleepTime.text          = @"你的休息时间";
    sleepTime.textAlignment = NSTextAlignmentCenter;
    sleepTime.textColor     = [UIColor whiteColor];
    if (mDevice < 8.0) {
        
        sleepTime.font          = [UIFont systemFontOfSize:14.4];
    } else {
        
        sleepTime.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:18];
        
    }
    
    //sleepTime.backgroundColor = [UIColor orangeColor];
    
    [sleepTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //make.centerX.equalTo(self.view.mas_centerX);
//        make.height.equalTo(@25);
//        make.width.equalTo(@108);
        if (mDevice < 8.0) {
            
            make.size.mas_equalTo(CGSizeMake(86.5, 20.5));
            make.left.equalTo(@((kScreenSize.width - 86.5) /2));
            make.top.equalTo(getUpTimeView.mas_bottom).offset(4.5);
        } else {
            
            make.size.mas_equalTo(CGSizeMake(108, 25));
            make.left.equalTo(@((kScreenSize.width - 108) /2));
            make.top.equalTo(getUpTimeView.mas_bottom).offset(6);
            
        }
        
    }];
    
       // 设定休息时间

    CGRect sleepRect;
    if (mDevice < 8.0) {
        
        sleepRect = CGRectMake(0, 0, 117.5, 40.5);
    } else {
        
        sleepRect = CGRectMake(0, 0, 147, 50);
        
    }
    
    LSInputView * sleepView   = [[LSInputView alloc] initWithFrame:sleepRect withType:@"time2"];
    sleepView.inputfeild.text = @"23:00";
    sleepView.unit.text       = @"PM";
    sleepView.delegate        = self;
    
    // 通过查询数据库结果设定起床时间
    [self setDataUseSelectResultWith:sleepView andResultString:self.sleepStr andString:@"23:00"];
    
    self.sleepView            = sleepView;
    [self.view addSubview:sleepView];
    
    [sleepView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (mDevice < 8.0) {
            
            make.top.equalTo(sleepTime.mas_bottom).offset(4);
        } else {
            
            make.top.equalTo(sleepTime.mas_bottom).offset(6);
        }
            make.centerX.equalTo(self.view);
    }];
    
    
    // 你的体重
    UILabel * weightLabel     = [[UILabel alloc] init];
    self.weightLabel          = weightLabel;
    weightLabel.text          = @"你的体重是多少";
    weightLabel.textAlignment = NSTextAlignmentCenter;
    weightLabel.textColor     = [UIColor whiteColor];
    if (mDevice < 8.0) {
        
        weightLabel.font          = [UIFont systemFontOfSize:14.4];
    } else {
        
        weightLabel.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:18];
    }

    [self.view addSubview:weightLabel];
    
    [weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (mDevice < 8.0) {
            
            make.height.equalTo(@20.5);
            make.width.equalTo(@101);
            make.left.equalTo(@((kScreenSize.width - 101) /2));
            make.top.equalTo(sleepView.mas_bottom).offset(4.5);
        } else {
            
            make.height.equalTo(@25);
            make.width.equalTo(@126);
            make.left.equalTo(@((kScreenSize.width - 126) /2));
            make.top.equalTo(sleepView.mas_bottom).offset(6);
        }

    }];
    
    // 体重
    

    CGRect weightRect;
    if (mDevice < 8.0) {
        
        weightRect = CGRectMake(0, 0, 117.5, 40.5);
    } else {
        
        weightRect = CGRectMake(0, 0, 147, 50);
        
    }
    LSInputView * weightView   = [[LSInputView alloc] initWithFrame:weightRect withType:@""];
    self.weightView            = weightView;

    // 通过查询数据库结果设定体重
    [self setDataUseSelectResultWith:weightView andResultString:self.weightStr andString:@"50"];

    weightView.delegate        = self;
    
    [self.view addSubview:weightView];
    
    [weightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (mDevice < 8.0) {
            
            make.top.equalTo(weightLabel.mas_bottom).offset(4);
            make.centerX.equalTo(self.view);
            make.left.right.equalTo(sleepView);
        } else {
            make.top.equalTo(weightLabel.mas_bottom).offset(6);
            make.centerX.equalTo(self.view);
            make.left.right.equalTo(sleepView);
        }
        
    }];

    
    // 每次饮水量
    UILabel * waterIntake     = [[UILabel alloc] init];
    self.waterIntake          = waterIntake;
    [self.view addSubview:waterIntake];
    waterIntake.text          = @"每次饮水量";
    waterIntake.textAlignment = NSTextAlignmentCenter;
    waterIntake.textColor     = [UIColor whiteColor];
    if (mDevice < 8.0) {
        
        waterIntake.font          = [UIFont systemFontOfSize:14.4];
    } else {
    waterIntake.font          = [UIFont fontWithName:@"PingFangSC-Thin" size:18];
    }
    
    [waterIntake mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.centerX.equalTo(self.view.mas_centerX);
        
        if (mDevice < 8.0) {
            
            make.height.equalTo(@20.5);
            make.width.equalTo(@101);
            make.left.equalTo(@((kScreenSize.width - 101) /2));
            make.top.equalTo(weightView.mas_bottom).offset(4.5);
        } else {
            make.height.equalTo(@25);
            make.width.equalTo(@108);
            make.left.equalTo(@((kScreenSize.width - 108) /2));
            make.top.equalTo(weightView.mas_bottom).offset(6);
        }
    }];
    
    
    // 饮水量

    CGRect waterRect;
    if (mDevice < 8.0) {
        
        waterRect = CGRectMake(0, 0, 115, 40.5);
    } else {
        
        waterRect = CGRectMake(0, 0, 147, 50);
        
    }
    LSInputView * waterView   = [[LSInputView alloc] initWithFrame:waterRect withType:@"special"];
    self.waterView            = waterView;
    waterView.delegate        = self;
    
    // 通过查询数据库结果设定饮水量
    [self setDataUseSelectResultWith:waterView andResultString:self.waterIntakeStr andString:@"300"];
    
    [self.view addSubview:waterView];
    
    [waterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (mDevice < 8.0) {
            
        make.top.equalTo(waterIntake.mas_bottom).offset(4.5);
        } else {
            
        make.top.equalTo(waterIntake.mas_bottom).offset(6);
            
        }
        
        make.centerX.equalTo(self.view);
        make.left.right.equalTo(sleepView);
    }];
    
    
    // 确定
    UIButton * confirm      = [[UIButton alloc] init];
    [self.view addSubview:confirm];
    
    // 你以后可以在设置中调整这些信息
    UILabel * bottomTips    = [[UILabel alloc] init];
    [self.view addSubview:bottomTips];
    
    
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirm.backgroundColor = [UIColor whiteColor];
    // 设置圆角
    [confirm.layer setMasksToBounds:YES];

    if (mDevice < 8.0) {
        [confirm.layer setCornerRadius:20];
        confirm.titleLabel.font = [UIFont systemFontOfSize:14.4];
    } else {
        [confirm.layer setCornerRadius:25];
        confirm.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        
    }


    [confirm addTarget:self action:@selector(didClickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (mDevice < 8.0) {
            make.bottom.equalTo(bottomTips.mas_top).offset(-7.2);
            make.size.mas_equalTo(CGSizeMake(140.4, 39.3));
        } else {
            make.bottom.equalTo(bottomTips.mas_top).offset(-9);
            make.size.mas_equalTo(CGSizeMake(175.5, 49));
        }
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    bottomTips.text      = @"你以后可以在设置中调整这些信息";
    bottomTips.textColor = [UIColor whiteColor];
    if (mDevice < 8.0) {
        bottomTips.font      = [UIFont systemFontOfSize:11.2];
    } else {
        bottomTips.font      = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }

    
    [bottomTips mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (mDevice < 8.0) {
            make.size.mas_equalTo(CGSizeMake(168, 16));
            make.bottom.equalTo(self.view).offset(-9);
            make.centerX.equalTo(self.view.mas_centerX);
        } else {
            make.size.mas_equalTo(CGSizeMake(210, 20));
            make.bottom.equalTo(self.view).offset(-9);
            make.centerX.equalTo(self.view.mas_centerX);
        }

    }];
    
}

#pragma mark UITextFeild代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    [self.view endEditing:YES] ;
    
    return YES;
}

#pragma mark 点击确定
- (void)didClickConfirmButton:(UIButton *)btn {
    
    
#pragma mark 点击按钮之后判断对应数据是否输入,然后将数据保存到本地
    
    
    if (![self.getUpTimeView.inputfeild.text  isEqual: @""] && ![self.sleepView.inputfeild.text isEqualToString:@""] && ![self.weightView.inputfeild.text isEqualToString:@""] && ![self.waterView.inputfeild.text isEqualToString:@""]) {
        
        
        // 保存数据
        [self insertDataWith:self.getUpTimeView.inputfeild.text andSleepStr:self.sleepView.inputfeild.text andWeightStr:self.weightView.inputfeild.text andWaterIntakeStr:self.waterView.inputfeild.text];
        
        
//        // 添加提醒通知
//        
//            // 如果系统式8.0之上需要注册通知
//        
//        /*
//        UIUserNotificationTypeNone    = 0,      // the application may not present any UI upon a notification being received
//        UIUserNotificationTypeBadge   = 1 << 0, // the application may badge its icon upon a notification being received
//        UIUserNotificationTypeSound   = 1 << 1, // the application may play a sound upon a notification being received
//        UIUserNotificationTypeAlert
//        */
//        
//        if (mDevice >= 8.0) {
//            UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)  categories:nil];
//            
//            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
//        }
//        
//        NSArray * moning = [self.getUpTimeView.inputfeild.text componentsSeparatedByString:@":"];
//
//        int moningHour = [moning[0] intValue];
//        int moningMinute = [moning[1] intValue];
//
//        NSArray * night = [self.sleepView.inputfeild.text componentsSeparatedByString:@":"];
//        
//        int nightHour = [night[0] intValue];
//        int nightMinute = [night[1] intValue];
//        
//        UILocalNotification *notification1=[[UILocalNotification alloc] init];
//        NSDate * date ;	
//        //判断第一个闹钟是否在早8点之前
//        if ((moningHour - 8)<0 & moningMinute > 0) {
//            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 +1)*60*60-moningMinute*60];//本次开启立即执行的周期
//        } else if((moningHour - 8)<0 & moningMinute == 0){
//            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
//        }else
//            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
//        
//        notification1.fireDate = [NSDate dateWithTimeInterval:5*60 sinceDate:date];
//        [self addAlarmNotification:notification1];
//        
//        UILocalNotification *notification2=[[UILocalNotification alloc] init];
//        notification2.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification1.fireDate];
//        [self addAlarmNotification:notification2];
//        
//        UILocalNotification *notification3=[[UILocalNotification alloc] init];
//        notification3.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification2.fireDate];
//        [self addAlarmNotification:notification3];
//        
//        UILocalNotification *notification4=[[UILocalNotification alloc] init];
//        notification4.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification3.fireDate];
//        [self addAlarmNotification:notification4];
//        
//        UILocalNotification *notification5=[[UILocalNotification alloc] init];
//        notification5.fireDate = [NSDate dateWithTimeInterval:2*60*60 sinceDate:notification4.fireDate];
//        [self addAlarmNotification:notification5];
//        
//        UILocalNotification *notification6=[[UILocalNotification alloc] init];
//        notification6.fireDate = [NSDate dateWithTimeIntervalSince1970:(nightHour -8)*60*60+nightMinute*60];
//        [self addAlarmNotification:notification6];

        // 关闭连接
        [self.database close];
        
        // 跳转到主界面
        LSMainViewController * mainVC = [[LSMainViewController alloc] init];
        
        [self presentViewController:mainVC animated:YES completion:^{
            
        }];
        
    }
}

//#pragma mark 抽出添加闹钟的方法
//- (void)addAlarmNotification:(UILocalNotification *)localNoti {
//
//    localNoti.repeatInterval=kCFCalendarUnitDay;//循环通知的周期 每天
//    localNoti.timeZone=[NSTimeZone defaultTimeZone];
//    localNoti.alertBody=@"该喝水了";//弹出的提示信息
//    localNoti.applicationIconBadgeNumber +=1 ; //应用程序的右上角小数字
//    localNoti.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
//    //notification.alertAction = NSLocalizedString(@"", nil);  //弹出的提示框按钮
//    localNoti.hasAction = NO;
//    [[UIApplication sharedApplication]   scheduleLocalNotification:localNoti];
//}

#pragma mark LSInputView 代理方法
- (void)inputViewDelegate {

    [self.view endEditing:YES];
}


#pragma mark 监听到键盘frame的变化的通知
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    if (!self.waterView.inputfeild.isEditing) {
        return;
    }else {
    
        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat transformY   = keyboardFrame.origin.y - self.view.bounds.size.height;
        self.view.transform  = CGAffineTransformMakeTranslation(0, transformY);
    }
    
}

#pragma mark  封装查询过程
- (void)selectWithState:(BOOL)success {

    if (success) {
        NSString *sql       = @"SELECT  getupStr,sleepStr,weightStr,waterIntakeStr FROM t_firstSeting ;";
        FMResultSet *result = [self.database executeQuery:sql];
        while ([result next]) {
            
            //起床时间 TEXT
            self.getupStr   =   [result stringForColumnIndex:0];
            //休息时间 TEXT
            self.sleepStr   =  [result stringForColumnIndex:1];
            //体重
            self.weightStr  =  [result stringForColumnIndex:2];
            //饮水量
            self.waterIntakeStr =  [result stringForColumnIndex:3];
        }
        //NSLog(@"getupTime = %@ sleepTime =  %@ weight = %@ waterIntake = %@",self.getupStr,self.sleepStr,self.weightStr,self.waterIntakeStr);
    }
}

#pragma mark  封装插入过程
- (void)insertDataWith:(NSString *)getupStr andSleepStr:(NSString *)sleepStr andWeightStr:(NSString *)weightStr andWaterIntakeStr:(NSString *)waterIntakeStr {

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  插入前删除前面插入的数据.
//
    NSString * tmpSql = [NSString stringWithFormat:@"DELETE FROM t_firstSeting ;"];

    BOOL tmpSuccess =  [self.database executeUpdate:tmpSql];
    if (tmpSuccess) {
        NSLog(@"FristPageViewController删除数据成功!");
    }else{
        NSLog(@"FristPageViewController删除数据失败!!");
    }

//
//////////////////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_firstSeting (getupStr,sleepStr,weightStr,waterIntakeStr) VALUES ('%@','%@','%@','%@')",getupStr,sleepStr,weightStr,waterIntakeStr];
    BOOL success =  [self.database executeUpdate:sql];
    if (success) {
        NSLog(@"FristPageViewController添加数据成功!");
    }else{
        NSLog(@"FristPageViewController添加数据失败!!");
    }
    
}

#pragma mark 通过查询结果设定控件数据
- (void)setDataUseSelectResultWith:(LSInputView *)view andResultString:(NSString *)resultString andString:(NSString *)preString {

    // 通过查询数据库结果设定起床时间
    if ([resultString isEqualToString:@""]) {
        view.inputfeild.text = preString;
    }else {
        view.inputfeild.text = resultString;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}



@end
