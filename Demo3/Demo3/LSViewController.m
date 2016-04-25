//
//  LSViewController.m
//  testCollection
//
//  Created by hanya on 16/4/21.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSViewController.h"
#import "Masonry.h"
#import "LSCollectionReusableView.h"
#import "LSCollectionViewCell.h"
#import "FMDatabase.h"
#import "KACircleProgressView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size



@interface LSViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic,weak)UIView * weekView;
@property (nonatomic,weak)UICollectionView * lsCollectionView;
// header的高
@property (nonatomic, assign) NSInteger headerH;

// 数据库
@property (nonatomic, weak) FMDatabase *database;


// 存储喝了的水量
@property (nonatomic, strong) NSArray *volumeArray;
// 存储目标水量
@property (nonatomic, strong) NSArray *totalArray;
// 存储时间
@property (nonatomic, strong) NSArray *fullTimeArray;

// 存储需要特殊显示的item的位置
@property (nonatomic, strong) NSArray *location;

@end

@implementation LSViewController


#pragma mark header高德懒加载,在此判断设备型号来确定高度以适配
- (NSInteger)headerH {

    return 50;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"%@",NSHomeDirectory());
    
    [ self getDataFromDB];
    
    
    self.title = @"详细记录";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.view.backgroundColor = [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    
    // 使view的区域从导航条以下开始算
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    // 盛放表示周几的label的view
//    UIView * weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width,21)];
//    self.weekView = weekView;
//    weekView.backgroundColor = [UIColor colorWithRed:44/255.0 green:50/255.0 blue:57/255.0 alpha:1.0];
//    [self.view addSubview:weekView];
    
//    
//    // 添加表示周几的label
//    
//    NSArray * weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
//    
    CGFloat labelW = kScreenSize.width / 7;
    CGFloat labelH = 21;
//
//    for (int i = 0; i < 7; ++i) {
//        
//        CGFloat labelX = labelW * i;
//        CGFloat labelY = 0;
//        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
//        label.text      = weekArray[i];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = [UIColor whiteColor];
//        label.font      = [UIFont systemFontOfSize:10];
//        
//        [self.weekView addSubview:label];
//    }
    
    
    // 添加collectionView
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize        = CGSizeMake(labelW,labelH);
    layout.minimumInteritemSpacing = 0;
    //layout.headerReferenceSize = CGSizeMake(kScreenSize.width, 50);
    
    layout.sectionInset    = UIEdgeInsetsMake(10, 0, 10, 0);
    
    UICollectionView * lsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64 ) collectionViewLayout:layout];
    
    lsCollectionView.backgroundColor = [UIColor clearColor ];
    // 注册cell
    [lsCollectionView registerClass:[LSCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    // 注册组头
    [lsCollectionView registerClass:[LSCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1"];
    
    lsCollectionView.delegate  = self;
    lsCollectionView.dataSource  = self;
    
    self.lsCollectionView = lsCollectionView;
    [self.view addSubview:lsCollectionView];
    
    
    NSLog(@"viewDidLoad----------");
}

// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    //取出时间数组的第一个元素和最后一个元素,来决定显示几组
    NSString *dateStr1 = self.fullTimeArray[0];
    NSString *dateStr2 = self.fullTimeArray.lastObject;
    
    
    NSLog(@"dateStr1----%@",dateStr1);
    NSLog(@"dateStr2----%@",dateStr2);
    
    NSInteger num = [self getMonthDiffrenceWithDateStr1:dateStr1 andDateStr2:dateStr2];
    
    
    //NSLog(@"numberOfSections----------");
    
    
    return num + 1 ;
    
    //return self.monthArray.count;
}

// 每组的item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    NSString * last = self.fullTimeArray.lastObject;
    NSString * yAndM = [last substringWithRange:NSMakeRange(0, 7)];
    
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = @"yyyy:MM";
    
    NSDate * date = [forma dateFromString:yAndM];
    
    NSDate * lastMonthDate = [self getPriousorLaterFromDate:date withMonth:-section];
    
    NSInteger num = [self getNumbersInMonth:lastMonthDate];
    
    
   // NSLog(@"numberOfItems----------");
    
    return num;
}
//返回item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LSCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor greenColor];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%zd",indexPath.item + 1];

    
    NSLog(@"cellForItemAtIndexPath----------%@",indexPath);
    
    //[self collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    
    
    NSInteger num = 0;
    BOOL isItem = NO;
    
    for (int i = 0; i < self.location.count; ++i) {
        
        NSLog(@"location----------%@",self.location[i]);
        
//        if (indexPath == self.location[i]) {
//            num = i;
//            isItem = YES;
//            break;
//        }
        NSIndexPath * location = self.location[i];
        if (indexPath.section == location.section & indexPath.item == location.item) {
            num = i;
            isItem = YES;
            break;
        }
    }
    
    NSLog(@"-------------%@-------------+++++++++++++++++++++",isItem ? @"YES" : @"NO");
    
    // 如果为真 则说明这个cell时目标cell,需要加特殊效果
    if (isItem == YES) {
        
        CGFloat volume = [self.volumeArray[num] floatValue];
        CGFloat total  = [self.totalArray[num] floatValue];
        
        NSLog(@"volume ============ %f",volume);
        NSLog(@"total ============ %f",total);
        
        if (volume > 0 & total > 0) {
            CGFloat percent = volume / total;
            //cell.backgroundColor = [UIColor greenColor];
            NSLog(@"%f",percent);
            
            
            KACircleProgressView *progress = [[KACircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            progress.center = CGPointMake(cell.bounds.size.width/2 -4, cell.bounds.size.height/2 +2);
            [cell.contentView addSubview:progress];
            progress.trackColor = [UIColor clearColor];
            progress.progressColor = [UIColor colorWithRed:23/255.0 green:138/255.0 blue:251/255.0 alpha:1];
            progress.progress = percent;
            progress.progressWidth = 3;
            
        }
        
        }
    
    isItem = NO;

    
    return cell;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {

    
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSInteger num = 0;
    BOOL isItem = NO;
    
    for (int i = 0; i < self.location.count; ++i) {
        if (indexPath == self.location[i]) {
            num = i;
            isItem = YES;
            break;
        }
    }
    
    // 如果为真 则说明这个cell时目标cell,需要加特殊效果
    if (isItem) {
        
        CGFloat volume = [self.volumeArray[num] floatValue];
        CGFloat total  = [self.totalArray[num] floatValue];
        
        NSLog(@"volume ============ %f",volume);
        NSLog(@"total ============ %f",total);
        
        if (volume > 0 & total > 0) {
            CGFloat percent = volume / total;
            //cell.backgroundColor = [UIColor greenColor];
            NSLog(@"%f",percent);
            
            
            KACircleProgressView *progress = [[KACircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
            
            progress.center = CGPointMake(cell.bounds.size.width/2 -6, cell.bounds.size.height/2 +2);
            [cell.contentView addSubview:progress];
            progress.trackColor = [UIColor clearColor];
            progress.progressColor = [UIColor colorWithRed:23/255.0 green:138/255.0 blue:251/255.0 alpha:1];
            progress.progress = percent;
            progress.progressWidth = 3;
            
        }
        
    }
    isItem = NO;

    
    return NO;
}


#pragma mark 此方法在iOS8.0以上适用
/*
// cell即将显示在view上
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

   // NSLog(@"willDisplayCell+++++++++++++++++++++++++++++++++");
    
    NSInteger num = 0;
    BOOL isItem = NO;
    
    for (int i = 0; i < self.location.count; ++i) {
        if (indexPath == self.location[i]) {
            num = i;
            isItem = YES;
            break;
        }
    }
    
    // 如果为真 则说明这个cell时目标cell,需要加特殊效果
    if (isItem) {
        
        CGFloat volume = [self.volumeArray[num] floatValue];
        CGFloat total  = [self.totalArray[num] floatValue];
        
        NSLog(@"volume ============ %f",volume);
        NSLog(@"total ============ %f",total);
        
        if (volume > 0 & total > 0) {
            CGFloat percent = volume / total;
            //cell.backgroundColor = [UIColor greenColor];
            NSLog(@"%f",percent);
            

            KACircleProgressView *progress = [[KACircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
            
            progress.center = CGPointMake(cell.bounds.size.width/2 -6, cell.bounds.size.height/2 +2);
            [cell.contentView addSubview:progress];
            progress.trackColor = [UIColor clearColor];
            progress.progressColor = [UIColor colorWithRed:23/255.0 green:138/255.0 blue:251/255.0 alpha:1];
            progress.progress = percent;
            progress.progressWidth = 3;
            
        }
        
    }
    isItem = NO;
}
 */

// 获取某个月有几天
- (NSInteger) getNumbersInMonth:(NSDate *)date {

    NSCalendar * calender = [NSCalendar currentCalendar];
    
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date ];
    
    return range.length;

}

// 指定时间字符串和转换格式获取日期对象
- (NSDate *)getDateUseString:(NSString *)dateStr andFormate:(NSString *)dateFormat {
    
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    forma.dateFormat   = dateFormat;
    
    return [forma dateFromString:dateStr];
}

// 根据两个时间字符串返回两个时间之间差几个月
- (NSInteger )getMonthDiffrenceWithDateStr1:(NSString *)dateStr1 andDateStr2:(NSString *)dateStr2 {

    NSString * str1 = [dateStr1 substringWithRange:NSMakeRange(0, 7)];
    NSString * str2 = [dateStr2 substringWithRange:NSMakeRange(0, 7)];
    
    NSDate * date1 = [self getDateUseString:str1 andFormate:@"yyyy:MM"];
    NSDate * date2 = [self getDateUseString:str2 andFormate:@"yyyy:MM"];

//    NSLog(@"%@",date1);
//    NSLog(@"%@",date2);
    
    NSCalendar * calender = [NSCalendar currentCalendar];
    
    NSDateComponents * component = [calender components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear fromDate:date1 toDate:date2 options:NSCalendarWrapComponents];
    
   // NSLog(@"首日期和末日期相差月数:%zd",component.month);

    if (component.month < 0) {
        return  3;
    }

    return component.month;
}

// 返回组的headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        LSCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header1" forIndexPath:indexPath];
        
        
        header.backgroundColor = [UIColor colorWithRed:36/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
        
//        NSString * date = self.monthArray[indexPath.section];
//        NSArray * dateComponent = [date componentsSeparatedByString:@":"];
//        NSString * year = [dateComponent firstObject];
//        NSString * month = dateComponent[1];
//        NSInteger monthNum = [month integerValue];
        
        NSString * last = self.fullTimeArray.lastObject;
        NSString * yAndM = [last substringWithRange:NSMakeRange(0, 7)];
        
        NSDateFormatter * forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy:MM";
        
        NSDate * date = [forma dateFromString:yAndM];
        
        NSDate * lastMonthDate = [self getPriousorLaterFromDate:date withMonth:-indexPath.section];
        
        
        NSString *lastDateStr = [forma stringFromDate:lastMonthDate];
        
        NSString *monthStr    = [lastDateStr substringWithRange:NSMakeRange(5, 2)];
        NSString *year        = [lastDateStr substringWithRange:NSMakeRange(0, 4)];
        
        header.dateLabel.text = [NSString stringWithFormat:@"%@年%@月",year,monthStr];
        
        return header;
    }
    
    return nil;
}

#pragma mark 获取指定时间的几个月前或几个月后的日期  正数为后  负为前
- (NSDate *)getPriousorLaterFromDate:(NSDate *)date withMonth:(NSInteger)month {

    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;

}

// 返回header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(kScreenSize.width, self.headerH);;
}

#pragma mark 从数据库拿取数据
- (void)getDataFromDB {

    NSMutableArray * tmpVolume = [NSMutableArray array];
    NSMutableArray * tmpTotal = [NSMutableArray array];
    NSMutableArray * tmpFullTime = [NSMutableArray array];
    
    NSString *path            = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"datafmdb.sqlite"];
    FMDatabase *database      = [FMDatabase databaseWithPath:path];
    self.database             = database;
    BOOL success              =  [database open];
    
    if (success) {
        
        NSString * sql = @"SELECT volume, total,fullTime FROM t_record";
        FMResultSet * result = [self.database executeQuery:sql];
        
        while ([result next]) {
            
            NSInteger volume = [result intForColumnIndex:0];
            [tmpVolume addObject:@(volume)];
            
            NSInteger total = [result intForColumnIndex:1];
            [tmpTotal addObject:@(total)];
            
            NSString * fullTime = [result stringForColumnIndex:2];
            
            
            
            [tmpFullTime addObject:fullTime];
        }
        
    }else NSLog(@"详细记录 -- 打开数据库失败");
    
    self.volumeArray = [tmpVolume copy];
    self.totalArray  = [tmpTotal copy];
    self.fullTimeArray = [tmpFullTime copy];

}


#pragma mark 在时间数组的set方法触发时计算出目标item的位置
-(void)setFullTimeArray:(NSArray *)fullTimeArray {


    _fullTimeArray = fullTimeArray;
    
//    for (NSString * fullTime in fullTimeArray) {
//        NSLog(@"fullTime++++++++++++%@",fullTime);
//    }
    
    NSString * last = fullTimeArray.lastObject;
    
    NSString * lastDay   = [last componentsSeparatedByString:@":"].lastObject;
    
    NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:(lastDay.integerValue - 1 ) inSection:0];
    
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    forma.dateFormat =@"yyyy:MM";

    
   // NSLog(@"lastDate--------%@",lastDate);
    
    NSMutableArray * tmpArray = [NSMutableArray array];
    
    
    for (int i = 0; i < (fullTimeArray.count - 1); ++i) {
        
        NSString * time = fullTimeArray[i];
        
       // NSLog(@"time++++++++++++++++++++++%@",time);
//
//        NSString * yandM = [last substringWithRange:NSMakeRange(0, 7)];
        NSString * day   = [time componentsSeparatedByString:@":"].lastObject;
//
        
        //NSLog(@"day++++++++++++++++++++++%@",day)   ;
        
//        NSDate * date = [forma dateFromString:yandM ];
        
        NSInteger num = [self getMonthDiffrenceWithDateStr1:fullTimeArray[i] andDateStr2:fullTimeArray.lastObject];
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:(day.integerValue - 1) inSection:num];
        
        [tmpArray addObject:indexPath];
    }
    
    [tmpArray addObject:lastIndexPath];
    
    self.location = [tmpArray copy];
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
