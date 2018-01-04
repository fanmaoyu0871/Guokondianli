//
//  GKButtonsView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKButtonsView.h"

@implementation GKButtonsView
{
    UIView *_moveLine;
    void (^_action)(NSInteger index, UIButton *btn);
    
    NSMutableArray *_btnArray;
    NSMutableArray *_verLineArray;
    
    UIView *_bottomLine;
}

-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data images:(NSArray*)images action:(void (^)(NSInteger index, UIButton *btn))block{
    if(self = [super initWithFrame:frame]){
        
        _btnArray = [NSMutableArray array];
        _verLineArray = [NSMutableArray array];
        
        CGFloat btnW = frame.size.width / data.count;
        for(NSInteger i = 0; i < data.count; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom image:nil fontSize:16 titleColor:HEXCOLOR(LightText_Color) title:data[i]];
            [btn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateSelected];
            btn.frame = CGRectMake(btnW*i+1, 0, btnW, frame.size.height - 2);
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if([images objectAtIndex:i]){
                [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            }
            
            if(i != data.count-1){
                UIView *line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(LightText_Color)];
                line.fm_size = CGSizeMake(0.5, 20);
                line.fm_left = btn.fm_right;
                line.fm_centerY = btn.fm_centerY;
                [self addSubview:line];
                [_verLineArray addObject:line];
            }

            [_btnArray addObject:btn];
        }
        
        _moveLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(MainTheme_Color)];
        _moveLine.fm_height = 2;
        _moveLine.fm_bottom = frame.size.height - 5;
        [self addSubview:_moveLine];
        
        _bottomLine = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        _bottomLine.fm_size = CGSizeMake(frame.size.width, 0.5);
        _bottomLine.fm_bottom = frame.size.height - 0.5;
        _bottomLine.fm_left = 0;
        [self addSubview:_bottomLine];
        
        _action = block;
    }
    
    return self;
}

-(void)btnAction:(UIButton*)btn{
    NSInteger index = btn.tag - 1000;
    
    for(UIButton *button in _btnArray){
        if(button != btn){
            button.selected = NO;
        }
    }
    
    _moveLine.fm_width = btn.titleLabel.intrinsicContentSize.width;
    _moveLine.fm_centerX = btn.fm_centerX;
    
    if(_action){
        btn.selected = !btn.isSelected;
        _action(index, btn);
    }
}
-(void)pressAtIndex:(NSInteger)index{
    UIButton *btn = (UIButton*)[self viewWithTag:1000+index];
    [self btnAction:btn];
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _moveLine.backgroundColor = _lineColor;
}

-(void)setTitleColor:(UIColor *)titleColor{
    
    for(UIButton *btn in _btnArray){
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor{
    for(UIButton *btn in _btnArray){
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
}

-(void)setShowVerticalLine:(BOOL)showVerticalLine{
    _showVerticalLine = showVerticalLine;
    for(UIView *line in _verLineArray){
        line.hidden = !showVerticalLine;
    }
}

-(void)setShowMoveLine:(BOOL)showMoveLine{
    _showMoveLine = showMoveLine;
    _moveLine.hidden = !showMoveLine;
}

-(void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    _bottomLine.hidden = !showBottomLine;
}

-(NSMutableArray *)btnArray{
    return _btnArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
