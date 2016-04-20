//
//  LSViewController.m
//  Demo3
//
//  Created by hanya on 16/4/19.
//  Copyright © 2016年 hanya. All rights reserved.
//

#import "LSViewController.h"

@interface LSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation LSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.testLabel.text = [NSString stringWithFormat:@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications] ];
    
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification * noti in array) {
        NSLog(@"%@",noti);
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    /*
    
    2016-04-19 21:40:58.593 Demo3[143:60b] <UIConcreteLocalNotification: 0x15df21d0>{fire date = 1970年1月1日 星期四 GMT+08007:05:00,
        time zone = Asia/Shanghai (GMT+8) offset 28800,
        repeat interval = NSDayCalendarUnit,
        repeat count = UILocalNotificationInfiniteRepeatCount,
        next fire date = 2016年4月20日 星期三 中国标准时间7:05:00,
        user info = (null)}
    
    
    
    
    
    
    2016-04-19 21:40:58.600 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d510e0>{fire date = 1970年1月1日 星期四 中国标准时间8:04:00,
        time zone = Asia/Shanghai (GMT+8) offset 28800,
        repeat interval = NSDayCalendarUnit,
        repeat count = UILocalNotificationInfiniteRepeatCount,
        next fire date = 2016年4月20日 星期三 中国标准时间8:04:00,
        user info = (null)}
    
    
    
    
    
    2016-04-19 21:40:58.606 Demo3[143:60b] <UIConcreteLocalNotification: 0x15dadc70>{fire date = 1970年1月1日 星期四 中国标准时间9:05:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间9:05:00, user info = (null)}
    
    
    
    
    
    2016-04-19 21:40:58.613 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d4f3a0>{fire date = 1970年1月1日 星期四 中国标准时间10:04:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间10:04:00, user info = (null)}
    2016-04-19 21:40:58.619 Demo3[143:60b] <UIConcreteLocalNotification: 0x15dfbda0>{fire date = 1970年1月1日 星期四 中国标准时间11:05:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间11:05:00, user info = (null)}
    2016-04-19 21:40:58.626 Demo3[143:60b] <UIConcreteLocalNotification: 0x15df0a30>{fire date = 1970年1月1日 星期四 中国标准时间12:04:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间12:04:00, user info = (null)}
    2016-04-19 21:40:58.632 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d4dcd0>{fire date = 1970年1月1日 星期四 中国标准时间13:05:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间13:05:00, user info = (null)}
    2016-04-19 21:40:58.639 Demo3[143:60b] <UIConcreteLocalNotification: 0x15dee9a0>{fire date = 1970年1月1日 星期四 中国标准时间14:04:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间14:04:00, user info = (null)}
    2016-04-19 21:40:58.645 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d4f640>{fire date = 1970年1月1日 星期四 中国标准时间15:05:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间15:05:00, user info = (null)}
    2016-04-19 21:40:58.652 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d4bef0>{fire date = 1970年1月1日 星期四 中国标准时间16:04:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月20日 星期三 中国标准时间16:04:00, user info = (null)}
    2016-04-19 21:40:58.658 Demo3[143:60b] <UIConcreteLocalNotification: 0x15df4710>{fire date = 1970年1月1日 星期四 中国标准时间22:00:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月19日 星期二 中国标准时间22:00:00, user info = (null)}
    2016-04-19 21:40:58.664 Demo3[143:60b] <UIConcreteLocalNotification: 0x15d503c0>{fire date = 1970年1月1日 星期四 中国标准时间23:00:00, time zone = Asia/Shanghai (GMT+8) offset 28800, repeat interval = NSDayCalendarUnit, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = 2016年4月19日 星期二 中国标准时间23:00:00, user info = (null)}

     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
