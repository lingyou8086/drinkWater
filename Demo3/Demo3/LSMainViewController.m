//
//  LSMainViewController.m
//  Demo3
//
//  Created by hanya on 16/4/1.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSMainViewController.h"
#import "Water.h"
#import "Masonry.h"
#import "NSString+Extension.h"
#import <sqlite3.h>
#import "FMDatabase.h"


#define mDevice  ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface LSMainViewController ()

// 完成时的控件
@property (nonatomic,weak)UIView * doneView;

// 每次饮水量
@property (nonatomic,assign) int waterIntake;
//总
@property (nonatomic,assign) float total;

// 记录喝水次数
@property (nonatomic,assign) int index ;

@property (nonatomic, strong) Water *waterView;
//顶部 提醒
@property (nonatomic, weak) UILabel *tips;
// 马上开始 按钮
@property (nonatomic, weak) UIButton *startBtn;
// 底部 提示(开启推送,将.....)
@property (nonatomic, weak) UILabel *bottomTip;

// 顶部设置按钮
@property (nonatomic, weak) UIButton *topSettingBtn;
// 进度label
@property (nonatomic, weak) UILabel *processLabel;
// 杯子图标
@property (nonatomic, weak) UIImageView *cupImageView;
// 记录
//@property (nonatomic, weak) UIImageView *record;
@property (nonatomic, weak) UIButton *record;

// 数据库
@property (nonatomic, strong) FMDatabase *database;
// 打开数据库是否成功
@property (nonatomic, assign) BOOL success;
@property (nonatomic,weak)    UIImageView * backImg ;
// 数据库中表字段
/*  id
	setButtonState      设置按钮的状态     NSIntager
	progress            进度             NSString
    lastTime            上次喝水时间      NSStri9ng
 */
@property (nonatomic, assign) NSInteger setButtonState;
@property (nonatomic, copy)   NSString *progress;
@property (nonatomic, copy)   NSString *lastTime;


@property (nonatomic, copy)   NSString *weightStr;

@end

@implementation LSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 1;
    
    self.view.backgroundColor = [UIColor colorWithRed:44/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
    
    
    
    // 创建/读取本地数据库
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];
    self.database             = database;
    BOOL success              =  [database open];
    self.success              =success;
    if (success) {
        NSLog(@"打开数据库成功!");
        
        // 执行查询表数据,给变量设置值
        [self selectWithState:success];
                
    }else{
        NSLog(@"创建数据库失败!");
    }
    
    
    
    // 背景动态水
    self.waterView = [[Water alloc] initWithFrame:(self.view.bounds)];
    [self.view addSubview:self.waterView];
    

    // 顶部 提醒
    UILabel * tips = [[UILabel alloc] init];
    self.tips      = tips;
    tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tips];
    
    
    if (mDevice < 8.0) {
        tips.font      = [UIFont systemFontOfSize:32];
    } else {
        tips.font      = [UIFont fontWithName:@"PingFangSC-Ultralight" size:36];
    }
    tips.text      = @"提醒";
    tips.textColor = [UIColor whiteColor];
    
    // 判断是否隐藏
    if (self.setButtonState == 0) {
        tips.hidden = NO;
    }else tips.hidden = YES;
    
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(72, 50));
        make.top.equalTo(self.view).offset(55);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    // 背景图片
//    UIImageView * backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 5"]];
//    self.backImg          = backImg;
//    [self.view addSubview:backImg];
//    
//    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.top.equalTo(self.tips.mas_bottom).offset(29);
//        make.centerX.equalTo(self.view);
//    }];
//    
//    if (self.setButtonState == 0) {
//        backImg.hidden = NO;
//    }else backImg.hidden = YES;
    
    

    
    // 底部label
    UILabel * bottomTip   = [[UILabel alloc] init];
    self.bottomTip        = bottomTip;
    bottomTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomTip];
    
//    if (mDevice < 8.0) {
//        bottomTip.font        =  [UIFont systemFontOfSize:28];
//    } else {
//        bottomTip.font        =  [UIFont fontWithName:@"PingFangSC-Regular" size:28];
//    }
//    
    
    // 马上开始按钮
    UIButton * startBtn      = [[UIButton alloc] init];
    self.startBtn            = startBtn;
    [self.view addSubview:startBtn];
    
    if (mDevice < 8.0) {
            startBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    } else {
        startBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:36];
    }

    
    if (self.setButtonState == 0) {
        
        bottomTip.text      = @"开启推送,将按计划提醒你喝水";
    }else {
        bottomTip.text      = [NSString stringWithFormat:@"上一次喝水的时间是:%@",self.lastTime];

    }
    
    bottomTip.textColor = [UIColor whiteColor];
    
    if (mDevice < 8.0) {
        bottomTip.font      = [UIFont systemFontOfSize:13];
    } else {
        bottomTip.font      = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
    
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize realSize = [bottomTip.text textSizewithFont:[UIFont systemFontOfSize:14] andMaxSize:maxSize];
    
    [bottomTip mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view).offset(-27);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(realSize);
        
    }];

    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor whiteColor]];
    
    if (mDevice < 8.0) {
        startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    } else {
        startBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    }
    
    
    [startBtn.layer setMasksToBounds:YES];
    [startBtn.layer setCornerRadius:25];
    
    if (self.setButtonState == 0) {
        [startBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    } else {
        [startBtn setTitle:@"喝水" forState:UIControlStateNormal];
        // 如果是第三种状态,则禁止按钮的点击
        startBtn.enabled  = self.setButtonState == 2 ? NO : YES;

    }
    
    [startBtn addTarget:self action:@selector(didClickStartButton:) forControlEvents:UIControlEventTouchUpInside];

    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(bottomTip.mas_top).offset(-9);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(175.5, 49));
    }];
    
    
    
    ///////////////////////////////////////点击开始之后显示的图标///////////////////////////
    
    // 设置按钮
    UIButton * topSettingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
    self.topSettingBtn       = topSettingBtn;
    [self.view addSubview:topSettingBtn];
    
    [topSettingBtn addTarget:self action:@selector(didClickSetingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [topSettingBtn setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];

    [topSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(17);
        make.top.equalTo(self.view).offset(18);
        //make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    if (self.setButtonState == 0) {
        topSettingBtn.hidden = YES;
    } else {
        topSettingBtn.hidden = NO;
    }
    
    
    // 进度label
    UILabel * processLabel   = [[UILabel alloc] init];
    self.processLabel        = processLabel;
    [self.view addSubview:processLabel];
    
    int total = 0;
    NSString * sql           = @"SELECT waterIntakeStr  FROM t_firstSeting ;";
    FMResultSet *result      = [self.database executeQuery:sql];
    while ([result next]) {
        
        self.waterIntake     = [result stringForColumnIndex:0].intValue;
        
        // 设置喝水总量
        //total                = self.waterIntake * 6 ;
        total                = self.weightStr.intValue * 40 ;
        self.total           = total;
    }
    
    processLabel.text        = [NSString stringWithFormat:@"%@/%dML",self.progress,total];
    processLabel.font        =  [UIFont fontWithName:@"PingFangSC-Light" size:17];
    processLabel.textColor   = [UIColor whiteColor];
    processLabel.textAlignment = NSTextAlignmentRight;
    if (self.setButtonState == 0) {
        processLabel.hidden = YES;
    } else {
        processLabel.hidden = NO;
    }
    
    [processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(120.5, 24));
        
        make.centerX.equalTo(self.view);
        //make.left.equalTo(topSettingBtn.mas_right).offset(95);
        make.top.equalTo(self.view).offset(15.5);
    }];
    
    // 杯子图标
    UIImageView * cupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drink 1"]];
    self.cupImageView          = cupImageView;
    [self.view addSubview:cupImageView];
    
    if (self.setButtonState == 0) {
        cupImageView.hidden = YES;
    } else {
        cupImageView.hidden = NO;
    }
    
    [cupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       // make.size.mas_equalTo(CGSizeMake(99.5, 24));
        make.centerY.equalTo(processLabel);
        make.left.equalTo(processLabel.mas_right);
    }];

    
    
    // 记录
//    UIImageView * record     =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notepad"]];
//    self.record              = record;
//    [self.view addSubview:record];

    
    UIButton * record       = [[UIButton alloc] init];
    [record setImage:[UIImage imageNamed:@"notepad"] forState:UIControlStateNormal];
    [record addTarget:self action:@selector(didClickRecord:) forControlEvents:UIControlEventTouchUpInside];
    self.record              = record;
    [self.view addSubview:record];
    
    
    if (self.setButtonState == 0) {
        record.hidden  = YES;
    } else {
        record.hidden  = NO;
    }
    

    [record mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(processLabel);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    
    ///////////////////////////////完成时的控件/////////////////////////////////////////
    UIView * doneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 28+14.5+54)];
    doneView.backgroundColor = [UIColor blackColor];
    UIImageView * doneCup = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 3"]];
    UILabel * doneLabel   = [[UILabel alloc] init];
    doneLabel.text        = @"今天的计划已完成";
    
    if (mDevice < 8.0) {
        doneLabel.font        = [UIFont systemFontOfSize:12];
    } else {
        doneLabel.font        = [UIFont fontWithName:@"PingFangSC-Light" size:20];
    }
    
    
    doneLabel.textColor   = [UIColor whiteColor];

    [doneView addSubview:doneLabel];
        [doneView addSubview:doneCup];
    
    [self.view addSubview:doneView];
    self.doneView         = doneView;
    
    
    [doneCup mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(doneView);
        make.centerX.equalTo(doneLabel);
    }];
    
    [doneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(doneView);
        make.top.equalTo(doneCup.mas_bottom).offset(14.5);
        make.height.equalTo(@28);
    }];
    


    [doneView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.view).offset(-100);
        make.centerX.equalTo(self.view);
    }];
    
    
    self.doneView.hidden = (self.setButtonState == 2 ? NO : YES);
    
    NSLog(@"%zd------%zd-------%zd",self.progress.floatValue , self.total,self.progress.floatValue / self.total);
    
    float initHeight = mDevice < 8.0 ? 120 : 200;
    
    self.waterView.height = (self.progress.floatValue / self.total) * ([UIScreen mainScreen].bounds.size.height - initHeight)  + initHeight;
    
    
    
    ///////////////////注册监听设置页面的通知/////////////////
     NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reciverSetNotification:) name:@"settingNotification" object:nil];
    
    
    
    
    ///////////////////如果是第二天,应该把页面还原  提示饮水完成的view隐藏 喝水进度清空  水位还原  喝水按钮状态还原 setButtonState 值设为1//////////////
    
    
    NSDate * today = [NSDate date];
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = @"MM:dd";
    NSString * todayStr = [forma stringFromDate:today];
    
    // 在数据库中取出最后一条记录的时间,如果比今天早一天,则刷新界面
    
    NSString * time1 ;
    
    NSString * sql1 = @"SELECT time FROM t_record";
    FMResultSet *result1 = [self.database executeQuery:sql1];
    
    while ([result1 next]) {
        time1 = [result1 stringForColumnIndex:0];
    }
    
    NSString * time2 = todayStr;
    
    
    NSDateFormatter * form = [[NSDateFormatter alloc] init];
    form.dateFormat = @"MM:dd";
    
    
    NSDate * date1 = [form dateFromString:time1];
    NSDate * date2 = [form dateFromString:time2];
    
    
    BOOL isEquel =  [date1 isEqualToDate:date2];
    
    if (!isEquel) {
        // 如果不相同,说明是新的一天
        
        self.progress = @"0";
        self.waterView.height = (self.progress.floatValue / self.total) * ([UIScreen mainScreen].bounds.size.height - initHeight)  + initHeight;
        self.processLabel.text        = [NSString stringWithFormat:@"%@/%dML",self.progress,total];
        
        self.startBtn.enabled = YES;
        self.doneView.hidden  = YES;
        
        self.setButtonState   = 1;
        NSString * sql2 = [NSString  stringWithFormat:@"UPDATE t_mainSeting SET setButtonState=1"];
        BOOL update = [self.database executeUpdate:sql2];
        
        if (update) {
            NSLog(@"更新setButtonState状态成功");
        } else {
            NSLog(@"更新setButtonState状态失败");
        }
    }
}

#pragma mark 点击马上开始/喝水
- (void)didClickStartButton:(UIButton *)btn {

    if ([btn.currentTitle isEqualToString:@"马上开始"]) {
        NSLog(@"点击马上开始");
        
        
        NSString * sql = @"UPDATE t_mainSeting SET setButtonState = 1;";
        
        BOOL success         =  [self.database executeUpdate:sql];
        
        if (success) {
            NSLog(@"数据更新成功");
        } else {
            NSLog(@"数据更新失败");
        }
        
        //self.tips.hidden = YES;
        self.setButtonState         = 1;
        self.tips.hidden            = YES;
        self.topSettingBtn.hidden   = NO;
        self.processLabel.hidden    =NO;
        self.cupImageView.hidden    = NO;
        self.record.hidden          = NO;
        
        [self.startBtn setTitle:@"喝水" forState:UIControlStateNormal];
        self.bottomTip.text         = [NSString stringWithFormat:@"上一次喝水的时间是:%@",self.lastTime];
        
#pragma mark 添加通知
        // 添加提醒通知
        
        // 如果系统式8.0之上需要注册通知
        
        /*
         UIUserNotificationTypeNone    = 0,      // the application may not present any UI upon a notification being received
         UIUserNotificationTypeBadge   = 1 << 0, // the application may badge its icon upon a notification being received
         UIUserNotificationTypeSound   = 1 << 1, // the application may play a sound upon a notification being received
         UIUserNotificationTypeAlert
         */
        
        if (mDevice >= 8.0) {
            UIUserNotificationSettings * setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert)  categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        }
        
        NSString * sqlForTime = @"SELECT getupStr, sleepStr FROM t_firstSeting";
        FMResultSet * resultForTime = [self.database executeQuery:sqlForTime];
        
        NSString * getup =@"";
        NSString * sleep =@"";
        
        while ([resultForTime next]) {
            getup = [resultForTime stringForColumnIndex:0];
            sleep = [resultForTime stringForColumnIndex:1];
        }
        
        
        NSArray * moning = [getup componentsSeparatedByString:@":"];
        
        int moningHour = [moning[0] intValue];
        int moningMinute = [moning[1] intValue];
        
        NSArray * night = [sleep componentsSeparatedByString:@":"];
        
        int nightHour = [night[0] intValue];
        int nightMinute = [night[1] intValue];
        
        UILocalNotification *notification1=[[UILocalNotification alloc] init];
        NSDate * date ;
        //判断第一个闹钟是否在早8点之前
        if ((moningHour - 8)<0 & moningMinute > 0) {
            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 +1)*60*60-(60-moningMinute)*60];//本次开启立即执行的周期
        } else if((moningHour - 8)<0 & moningMinute == 0){
            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
        }else
            date = [NSDate dateWithTimeIntervalSince1970:(moningHour - 8 )*60*60];
        
        notification1.fireDate = [NSDate dateWithTimeInterval:5*60 sinceDate:date];// date 时间是早晨7点
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

    }else {
    
        NSLog(@"喝水");
        
        self.progress = [NSString stringWithFormat:@"%d",self.waterIntake + self.progress.intValue ];
        
        NSLog(@"%zd------%zd-------%zd",self.progress.floatValue , self.total,self.progress.floatValue / self.total);
        
        self.waterView.height = (float)(self.progress.floatValue / self.total) * ([UIScreen mainScreen].bounds.size.height - 200)  + 200;
        
        self.processLabel.text = [NSString stringWithFormat:@"%@/%.0fML",self.progress,self.total];
        
        
        // 取出当前时间
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm";
        NSString * time = [formatter stringFromDate:date];
        
        // 保存数据'
        NSString * sql =   [NSString stringWithFormat:@"UPDATE t_mainSeting SET progress='%@',lastTime='%@';",self.progress,time];
        
        BOOL success         =  [self.database executeUpdate:sql];
        
        if (success) {
            //NSLog(@"数据更新成功");
        } else {
            //NSLog(@"数据更新失败");
        }

        self.lastTime = time;
        self.bottomTip.text = [NSString stringWithFormat:@"上一次喝水的时间是:%@",self.lastTime];
        
        
        /////////////////////向表3中写入数据////////////////////////
        
        formatter.dateFormat = @"MM:dd";
        
        NSString *timeStr = [formatter stringFromDate:date];
        NSLog(@"%@",timeStr);
        // 加入一条详细时间,方便详细记录使用
        formatter.dateFormat = @"yyyy:MM:dd";
        NSString * fullTime  = [formatter stringFromDate:date];
        NSLog(@"fullTime------%@",fullTime);
        
        // 先查找 如果没有今天的记录就先增加一条   如果有就更新
        
        NSString * sql3_1 = [NSString stringWithFormat:@"SELECT time FROM t_record WHERE time = '%@';",timeStr];
        
        FMResultSet * result = [self.database executeQuery:sql3_1];
        
        if ([result next]) {
            // 已存在
            NSString * sql3_2 =   [NSString stringWithFormat:@"UPDATE t_record SET time='%@',volume='%@',total='%d',fullTime='%@' WHERE time = '%@';",timeStr,self.progress,(int)self.total,fullTime,timeStr];
            
            BOOL success3         =  [self.database executeUpdate:sql3_2];
            
            if (success3) {
                NSLog(@"+fullTime数据更新成功");
            } else {
                NSLog(@"+fullTime数据更新失败");
            }

        } else {
            // 不存在  插入一条
            NSString * sql3_3 =   [NSString stringWithFormat:@"INSERT INTO t_record(time,volume,total,fullTime) VALUES('%@','%d','%d','%@')",timeStr,self.progress.intValue,(int)self.total,fullTime];
            
            BOOL success3         =  [self.database executeUpdate:sql3_3];
            
            if (success3) {
                NSLog(@"+fullTime数据插入成功");
            } else {
                NSLog(@"+fullTime数据插入失败");
            }
        }
    }
 
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


#pragma mark   喝水进度的懒加载 及控制喝水按钮的状态

- (void)setProgress:(NSString *)progress {

    _progress = progress;
    
    if (progress.intValue >= self.total) {
        
        // 喝够了   这时主页面应处于第三种状态 (0 未开始喝水  1 喝水 2 喝足)
        
        //NSLog(@"喝够了");
        
        self.startBtn.enabled = NO;
        
        
        // 第三种状态时   中间加一个view 放图片和文字    startBtn的状态时禁止
        self.doneView.hidden  = NO;
        NSString * sql = @"UPDATE t_mainSeting SET setButtonState = 2;";
        
        BOOL success         =  [self.database executeUpdate:sql];
        
        if (success) {
            //NSLog(@"数据更新成功");
        } else {
            //NSLog(@"数据更新失败");
        }
  
    }
 
}



#pragma mark  封装查询过程
- (void)selectWithState:(BOOL)success {
    
    //t_mainSeting(setButtonState, progressLabelState,cupState,recordLabelState,topTipLabelState,buttonState,bottomTipLabelState,progress)
    
    if (success) {
        NSString *sql       = @"SELECT  setButtonState,progress,lastTime FROM t_mainSeting ;";
        FMResultSet *result = [self.database executeQuery:sql];
        while ([result next]) {
            
            //
            self.setButtonState       =   [result intForColumnIndex:0];
            NSLog(@"%zd",self.setButtonState);
            //
            _progress             =   [result stringForColumnIndex:1];
            NSLog(@"%@--------",self.progress);
            self.lastTime             =   [result stringForColumnIndex:2];
            NSLog(@"%@--------",self.lastTime);
        }
        
        // 查询体重
        NSString *sql1       = @"SELECT weightStr  FROM t_firstSeting;";
        FMResultSet *result1 = [self.database executeQuery:sql1];
        while ([result1 next]) {
            
            //
            self.weightStr       =   [result1 stringForColumnIndex:0];
            NSLog(@"%@--------",self.weightStr);
            
        }

    }
}


#pragma mark 点击设置


- (void)didClickSetingBtn:(UIButton *)setBtn {


    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LSSeting" bundle:nil];
    UINavigationController * nav = [story instantiateViewControllerWithIdentifier:@"set"];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark 点击记录图标

- (void)didClickRecord:(UIButton *)recordBtn {

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"LSRecord" bundle:nil];
    UINavigationController * nav = [story instantiateViewControllerWithIdentifier:@"record"];
    
    [self presentViewController:nav animated:YES completion:nil];

}



#pragma mark  接收到 更改设置后的通知  刷新进度label的文字  喝水按钮的状态   显示喝水完成的view的状态  水位的高低   早晚的提醒通知时间
- (void)reciverSetNotification:(NSNotification *)noti {

    // 刷新主页数据
    
    [self selectWithState:YES];
    
    self.total = self.weightStr.floatValue * 40 ;
    
    self.waterView.height = (float)(self.progress.floatValue / self.total) * ([UIScreen mainScreen].bounds.size.height - 200)  + 200;
    
    self.processLabel.text = [NSString stringWithFormat:@"%@/%.0fML",self.progress,self.total];
    
    if (self.progress.floatValue < self.total ) {
        self.startBtn.enabled = YES;
    }
    
    
    

}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {

    return YES;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//
//    return UIStatusBarStyleLightContent;
//}

@end
