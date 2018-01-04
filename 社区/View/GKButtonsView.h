//
//  GKButtonsView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKButtonsView : UIView
-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data images:(NSArray*)images action:(void (^)(NSInteger index, UIButton *btn))block;

-(void)pressAtIndex:(NSInteger)index;

@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, assign)BOOL showVerticalLine;
@property (nonatomic, assign)BOOL showMoveLine;
@property (nonatomic, assign)BOOL showBottomLine;
@property (nonatomic, strong, readonly)NSMutableArray *btnArray;
@end
