//
//  FMBubbleTabbar.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "FMBubbleTabbar.h"

@interface FMNoHighlightButton:UIButton
@end

@implementation FMNoHighlightButton
-(void)setHighlighted:(BOOL)highlighted{
    
}
@end

@interface FMBubbleTabbar()
{
    UIButton *_preBtn;
}

@property (nonatomic, copy)void (^SelectedBlock)(NSInteger index);
@property (nonatomic, copy)void (^CenterBlock)(void);

@end

@implementation FMBubbleTabbar

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles images:(NSArray*)images selectedImages:(NSArray*)selectedImages selectedBlock:(void (^)(NSInteger index))selectedBlock centerBlock:(void (^)(void))centerBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.SelectedBlock = selectedBlock;
        self.CenterBlock = centerBlock;
        
        NSInteger count = images.count;
        CGFloat btnW = ScreenWidth / count;
        
        NSInteger index = 0;
        for(NSInteger i = 0; i < count; i++){
            UIButton *btn = nil;
            
            if(i != 2){
                btn = [[FMNoHighlightButton alloc]init];
                btn.tag = 1000 + index;
                index++;
            }else{
                btn = [[UIButton alloc]init];
                btn.tag = 1000 + 9;
            }
            btn.frame = CGRectMake(i*btnW, i==2?-25:0, btnW, i==2?69:49);
            [self addSubview:btn];
            
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if(i == 0){
                [self btnAction:btn];
            }
        }
        
    }
    return self;
}

+(instancetype)tabTitles:(NSArray*)titles images:(NSArray*)images selectedImages:(NSArray*)selectedImages selectedBlock:(void (^)(NSInteger index))selectedBlock centerBlock:(void (^)(void))centerBlock{
    FMBubbleTabbar *tabbar = [[self alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49) titles:titles images:images selectedImages:selectedImages selectedBlock:selectedBlock centerBlock:centerBlock];
    
    return tabbar;
}

-(void)btnAction:(UIButton*)btn{
    NSInteger index = btn.tag - 1000;
    
    if(index == 9){
        if(self.CenterBlock){
            self.CenterBlock();
        }
    }else{
        
        if(_preBtn == btn)
            return;
        
        _preBtn.selected = NO;
        btn.selected = YES;
        _preBtn = btn;
        
        if(self.SelectedBlock){
            self.SelectedBlock(index);
        }
    }
}

-(void)pressAtIndex:(NSInteger)index{
    [self btnAction:[self viewWithTag:1000+index]];
}




@end
