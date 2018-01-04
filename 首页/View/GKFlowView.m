//
//  GKFlowView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/21.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKFlowView.h"

@interface GKFlowView()
@property (nonatomic, assign)CGSize itemSize;
@property (nonatomic, assign)CGFloat lineSpace;
@property (nonatomic, copy)NSArray *dataArray;
@property (nonatomic, assign)NSInteger rowCount;
@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, copy)void (^BtnBlock)(NSInteger index, UIButton *btn);
@end

@implementation GKFlowView

-(NSMutableArray *)btnArray{
    if(_btnArray == nil){
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data rowCount:(NSInteger)rowCount itemSize:(CGSize)itemSize lineSpace:(CGFloat)lineSpace block:(void (^)(NSInteger index, UIButton *btn))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSize = itemSize;
        self.lineSpace = lineSpace;
        self.dataArray = data;
        self.rowCount = rowCount;
        
        self.selectedTitleColor = HEXCOLOR(MainTheme_Color);
        self.normalTitleColor = HEXCOLOR(TableBackground_Color);
        self.normalBgColor = HEXCOLOR(0xffffff);
        self.selectedBgColor = HEXCOLOR(0xffffff);
        self.normalBorderColor = HEXCOLOR(TableBackground_Color);
        self.selectedBorderColor = HEXCOLOR(MainTheme_Color);
        
        CGFloat viewW = frame.size.width / rowCount;
        CGFloat viewH = itemSize.height + lineSpace*2;
        for(NSInteger i = 0; i < data.count; i++){
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(viewW*(i%rowCount), viewH*(i/rowCount), viewW, viewH)];
            [self addSubview:bgView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom image:nil fontSize:14.0f titleColor:HEXCOLOR(NormalText_Color) title:data[i]];
            [btn setTitleColor:self.normalTitleColor forState:UIControlStateSelected];
            btn.backgroundColor = self.normalBgColor;
            btn.fm_size = itemSize;
            btn.center = bgView.fm_boundsCenter;
            [bgView addSubview:btn];
            btn.layer.cornerRadius = 2;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = self.normalBorderColor.CGColor;
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArray addObject:btn];
        }
        
        CGFloat totalH = viewH * (self.dataArray.count%self.rowCount == 0?(self.dataArray.count/self.rowCount):(self.dataArray.count/self.rowCount + 1));
        self.fm_height = totalH;
        
        self.BtnBlock = block;
    }
    return self;
}

-(void)btnAction:(UIButton*)btn{
    
    if(btn.isSelected){
        for(UIButton *btn in self.btnArray){
            btn.selected = NO;
            btn.layer.borderColor = self.normalBorderColor.CGColor;
            [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
            btn.backgroundColor = self.normalBgColor;
        }
        
    }else{
        for(UIButton *btn in self.btnArray){
            btn.selected = NO;
            btn.layer.borderColor = self.normalBorderColor.CGColor;
            [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
            btn.backgroundColor = self.normalBgColor;
        }
        
        btn.selected = YES;
        btn.layer.borderColor = self.selectedBgColor.CGColor;
        btn.backgroundColor = self.selectedBgColor;
        [btn setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
    }
    
    NSInteger index = btn.tag - 1000;
    if(self.BtnBlock){
        self.BtnBlock(index, btn);
    }
}

-(CGFloat)heightForData{
    CGFloat viewH = self.itemSize.height + self.lineSpace*2;
    CGFloat totalH = viewH * (self.dataArray.count%self.rowCount == 0?(self.dataArray.count/self.rowCount):(self.dataArray.count/self.rowCount + 1));

    return totalH;
}

//取消选中所有按钮
- (void)cancelAllBtn{
    for(UIButton *btn in self.btnArray){
        btn.selected = NO;
        btn.layer.borderColor = self.normalBorderColor.CGColor;
        [btn setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        btn.backgroundColor = self.normalBgColor;
    }
}

//禁用/可用 所有按钮
- (void)enableAllBtn:(BOOL)enable{
    for(UIButton *btn in self.btnArray){
        btn.enabled = enable;
    }
}

-(void)setNormalBgColor:(UIColor *)normalBgColor{
    _normalBgColor = normalBgColor;
    
    for(UIButton *btn in self.btnArray){
        btn.backgroundColor = normalBgColor;
    }
}

-(void)setSelectedBgColor:(UIColor *)selectedBgColor{
    _selectedBgColor = selectedBgColor;
    
    for(UIButton *btn in self.btnArray){
        btn.backgroundColor = selectedBgColor;
    }
}

-(void)setNormalTitleColor:(UIColor *)normalTitleColor{
    _normalTitleColor = normalTitleColor;
    
    for(UIButton *btn in self.btnArray){
        [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}

-(void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    _selectedTitleColor = selectedTitleColor;
    
    for(UIButton *btn in self.btnArray){
        [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }
}

-(void)setNormalBorderColor:(UIColor *)normalBorderColor{
    _normalBorderColor = normalBorderColor;
    for(UIButton *btn in self.btnArray){
        btn.layer.borderColor = normalBorderColor.CGColor;
    }
}

-(void)setSelectedBorderColor:(UIColor *)selectedBorderColor{
    _selectedBorderColor = selectedBorderColor;
    
    for(UIButton *btn in self.btnArray){
        btn.layer.borderColor = selectedBorderColor.CGColor;
    }
}



@end
