//
//  GKFlowView.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKFlowView : UIView

@property (nonatomic, strong)UIColor *normalBgColor;
@property (nonatomic, strong)UIColor *selectedBgColor;
@property (nonatomic, strong)UIColor *normalBorderColor;
@property (nonatomic, strong)UIColor *selectedBorderColor;
@property (nonatomic, strong)UIColor *normalTitleColor;
@property (nonatomic, strong)UIColor *selectedTitleColor;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data rowCount:(NSInteger)rowCount itemSize:(CGSize)itemSize lineSpace:(CGFloat)lineSpace block:(void (^)(NSInteger index, UIButton *btn))block;

//取消选中所有按钮
- (void)cancelAllBtn;

//禁用所有按钮
- (void)enableAllBtn:(BOOL)enable;

-(CGFloat)heightForData;


@end
