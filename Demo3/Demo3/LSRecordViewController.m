//
//  LSRecordViewController.m
//  Demo3
//
//  Created by hanya on 16/4/13.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSRecordViewController.h"
#import "UUChart.h"
#import "FMDatabase.h"
#import "LSViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size



@interface LSRecordViewController ()<UUChartDataSource>


- (IBAction)detailRecord:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *dayVolume;
@property (weak, nonatomic) IBOutlet UILabel *totalVolme;
- (IBAction)didClickBack:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation LSRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    // 改变标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    
//    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:44/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]] ;
    
    // 创建/读取本地数据库
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];
    self.database             = database;
    BOOL success              =  [database open];
    if (success) {
        
        NSLog(@"打开数据库成功!");
        //
        
    }else{
        NSLog(@"失败!!");
    }

    
    
    
    UUChart * barView = [[UUChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.flagView.frame), kScreenSize.width, kScreenSize.height - CGRectGetMaxY(self.flagView.frame) -5) dataSource:self style:UUChartStyleBar];
    
    barView.backgroundColor = [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    
    [barView showInView:self.view];
 
    
    
    //[self getDataFromDataBase];
    
}


//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart{

    return @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
}

//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart{

    //return @[@[@"1800",@"600",@"900",@"1800",@"300",@"900",@"600"],@[@"600",@"900",@"300",@"1800",@"600",@"900",@"300"]];
    
    return self.resultArray;
}


//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart{

    return @[[UIColor grayColor],[UIColor colorWithRed:54/255.0 green:175/255.0 blue:252/255.0 alpha:1]];
}

#pragma mark 获取要展示的数据
- (NSArray *)getDataFromDataBase{
    
    
    NSMutableArray * thisWeek = [NSMutableArray array];
    NSMutableArray * lastWeek = [NSMutableArray array];
    
    
    // 1  获取今天是周几
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate * now;
    
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    
    now = [NSDate date];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = @"MM:dd";
    
    NSInteger today =  [comps weekday];
    
    //today = 1;
    
    int totalVolume = 0;
    
    // 本周   today == 1 标示今天是周末
    if (today != 1) {
        
        // 取本周出去今天的前几天
        
        
        for (int i = (int)today - 2  ; i > 0; --i) {
            
            NSDate * preDay = [NSDate dateWithTimeInterval:-24*60*60*i sinceDate:now];
            
            NSString * dateStr = [forma stringFromDate:preDay];
            
            
            // 在数据库中查询数据    t_record    id  time  volume
            NSString * sql = [NSString stringWithFormat:@"SELECT volume FROM t_record WHERE time ='%@';",dateStr];
            
            FMResultSet * result        =  [self.database executeQuery:sql];
            
            while ([result next]) {
                
                int  volume = [result intForColumnIndex:0];
                totalVolume += volume;
                [thisWeek addObject:@(volume)];
            }
            
        }
        
        // 今天
        
        NSString * dateStr = [forma stringFromDate:now];
        
        NSString * sql = [NSString stringWithFormat:@"SELECT volume FROM t_record WHERE time ='%@';",dateStr];
        
        FMResultSet * result        =  [self.database executeQuery:sql];
        
        while ([result next]) {
            
            int  volume = [result intForColumnIndex:0];
            
            totalVolume += volume;
            
            [thisWeek addObject:@(volume)];
        }
        
        
    }else { // 今天是周末的情况    today == 1
        
        for (int i = 1  ; i < 8; ++i) {
            
            NSDate * preDay = [NSDate dateWithTimeInterval:-24*60*60*(7-i) sinceDate:now];
            
            NSString * dateStr = [forma stringFromDate:preDay];
            
            //NSLog(@"%@",dateStr);
            
            // 在数据库中查询数据    t_record    id  time  volume
            NSString * sql = [NSString stringWithFormat:@"SELECT volume FROM t_record WHERE time ='%@';",dateStr];
            
            FMResultSet * result        =  [self.database executeQuery:sql];
            
            while ([result next]) {
                
                int  volume = [result intForColumnIndex:0];
                
                totalVolume += volume;
                
                [thisWeek addObject:@(volume)];
            }
            
        }
 
    }
    
    
    self.dayVolume.text  = [NSString stringWithFormat:@"%@ml",[thisWeek lastObject] ? [thisWeek lastObject]:@"0"];
    
    self.totalVolme.text = [NSString stringWithFormat:@"%dml",totalVolume ];
    
    // 上周
    
    if (today != 1) {
        
        for (int i = 0  ; i < 7; ++i) {
            
            NSDate * preDay = [NSDate dateWithTimeInterval:-24*60*60*(5+today -i) sinceDate:now];
            
            NSString * dateStr = [forma stringFromDate:preDay];
            //NSLog(@"------%@",dateStr);
            
            // 在数据库中查询数据    t_record    id  time  volume
            NSString * sql = [NSString stringWithFormat:@"SELECT volume FROM t_record WHERE time ='%@';",dateStr];
            
            FMResultSet * result        =  [self.database executeQuery:sql];
            
            while ([result next]) {
                
                int  volume = [result intForColumnIndex:0];
                [lastWeek addObject:@(volume)];
            }
        }

    } else {
        
        for (int i = 13  ; i > 6; --i) {
            
            NSDate * preDay = [NSDate dateWithTimeInterval:-24*60*60*i sinceDate:now];
            
            NSString * dateStr = [forma stringFromDate:preDay];
            //NSLog(@"------%@",dateStr);
            
            // 在数据库中查询数据    t_record    id  time  volume
            NSString * sql = [NSString stringWithFormat:@"SELECT volume FROM t_record WHERE time ='%@';",dateStr];
            
            FMResultSet * result        =  [self.database executeQuery:sql];
            
            while ([result next]) {
                
                int  volume = [result intForColumnIndex:0];
                [lastWeek addObject:@(volume)];
            }
        }

    }
    
    
    
    
    NSArray * resultArray = [NSArray arrayWithObjects:lastWeek,thisWeek, nil];
    
    //NSLog(@"%@",resultArray);
    
    return resultArray;
    
}

- (IBAction)detailRecord:(UIBarButtonItem *)sender {
}

#pragma mark 懒加载
- (NSArray *)resultArray {

    if (!_resultArray) {
        
        _resultArray = [self getDataFromDataBase];
        
    }
    
    return _resultArray;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleDefault;
//}

// 点击返回
- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark 点击进入详细记录页面
- (IBAction)didClickDetailRecord:(UIBarButtonItem *)sender {
    
    LSViewController * vc = [[LSViewController alloc] init];
    
    // 去掉详细页面返回按钮的文字
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
