//
//  YLBDatePicker.m
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "YLBDatePicker.h"

#define AnimateY 250.0f

@interface  YLBDatePicker()

@property (nonatomic, copy)DatePickerBlock leftBlock;
@property (nonatomic, copy)DatePickerBlock rightBlock;
@property (nonatomic, copy)NSString *leftTitle;
@property (nonatomic, copy)NSString *rightTitle;
@property (nonatomic, copy)NSString *limitDate;

@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;

@property (nonatomic, strong)UIDatePicker *picker;
@property (nonatomic, assign)UIDatePickerMode pickerMode;

@property (nonatomic, strong)UIView *realView;

@end


@implementation YLBDatePicker

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self leftBtnAction];
}

-(void)setPickerMode:(UIDatePickerMode)pickerMode{
    _pickerMode = pickerMode;
    self.picker.datePickerMode = pickerMode;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.realView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, AnimateY)];
        [self addSubview:self.realView];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 44.0f)];
        topView.backgroundColor = [UIColor whiteColor];
        [self.realView addSubview:topView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, topView.fm_bottom - 1.0f, topView.fm_width, 1.0f)];
        line.backgroundColor = [UIColor colorWithHex:TableBackground_Color];
        [topView addSubview:line];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.leftBtn setTitleColor:[UIColor colorWithHex:NormalText_Color] forState:UIControlStateNormal];
        self.leftBtn.frame = CGRectMake(0, 0, 60, topView.fm_height);
        [topView addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.rightBtn setTitleColor:[UIColor colorWithHex:MainTheme_Color] forState:UIControlStateNormal];
        self.rightBtn.frame = CGRectMake(topView.fm_width - 60, 0, 60, topView.fm_height);
        [topView addSubview:self.rightBtn];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, topView.fm_bottom, frame.size.width, AnimateY - 44.0f)];
        _picker.backgroundColor = [UIColor whiteColor];
        self.picker.datePickerMode = UIDatePickerModeDate;
        self.picker.date = [NSDate date];
        [self.picker setLocale:[NSLocale currentLocale]];
        [self.realView addSubview:self.picker];
    }
    return self;
}

-(void)setLeftTitle:(NSString *)leftTitle{
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
}

-(void)setRightTitle:(NSString *)rightTitle{
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

-(void)setLimitDate:(NSString *)limitDate{
    _limitDate = limitDate;
    
    if(_limitDate){
        NSDateFormatter *fm = [[NSDateFormatter alloc]init];
        fm.dateFormat = @"yyyy-MM-dd";
        NSDate *minDate = [fm dateFromString:_limitDate];
        self.picker.minimumDate = minDate;
    }
}

-(void)leftBtnAction{
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y += AnimateY;
    } completion:^(BOOL finished) {
        if(self.leftBlock){
            self.leftBlock(self.picker.date);
        }
        [self removeFromSuperview];
    }];
}

-(void)rightBtnAction{
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y += AnimateY;
    } completion:^(BOOL finished) {
        if(self.rightBlock){
            self.rightBlock(self.picker.date);
        }
        [self removeFromSuperview];
    }];
}

-(void)show{
    [UIView animateWithDuration:0.3f animations:^{
        self.realView.fm_y -= AnimateY;
    }];
}

+(void)showPickerType:(UIDatePickerMode)type LeftTitle:(NSString*)leftTitle leftAction:(DatePickerBlock)leftBlock rightTitle:(NSString*)rightTitle rightAction:(DatePickerBlock)rightBlock limitDate:(NSString*)limitDate{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    YLBDatePicker *picker = [[self alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    picker.leftBlock = leftBlock;
    picker.rightBlock = rightBlock;
    picker.leftTitle = leftTitle;
    picker.rightTitle = rightTitle;
    picker.limitDate = limitDate;
    picker.pickerMode = type;
    [window addSubview:picker];
    
    [picker show];
}

@end
