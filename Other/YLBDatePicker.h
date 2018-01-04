//
//  YLBDatePicker.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DatePickerBlock)(NSDate *date);

@interface YLBDatePicker : UIView

//limitDate 限制最小时间
+(void)showPickerType:(UIDatePickerMode)type LeftTitle:(NSString*)leftTitle leftAction:(DatePickerBlock)leftBlock rightTitle:(NSString*)rightTitle rightAction:(DatePickerBlock)rightBlock limitDate:(NSString*)limitDate;

@end
