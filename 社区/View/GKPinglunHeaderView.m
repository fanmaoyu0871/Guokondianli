//
//  GKPinglunHeaderView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/27.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKPinglunHeaderView.h"

#import "GKPinglunTopView.h"
#import "GKPinglunLinkView.h"
#import "GKPinglunZanView.h"

@interface GKPinglunHeaderView()
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)GKPinglunTopView *topView;
@property (nonatomic, strong)GKPinglunLinkView *linkView;
@property (nonatomic, strong)GKPinglunZanView *zanView;
@end

@implementation GKPinglunHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _topView = [[GKPinglunTopView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
        [self addSubview:_topView];
        
        self.contentLabel = [UILabel labelWithTitle:@"" fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        
        _linkView = [[GKPinglunLinkView alloc]initWithFrame:CGRectMake(70, self.contentLabel.fm_bottom + 10, frame.size.width-80, 60)];
        [self addSubview:_linkView];
        
        _zanView = [[GKPinglunZanView alloc]initWithFrame:CGRectMake(0, _linkView.fm_bottom, frame.size.width, 50)];
        [self addSubview:_zanView];
    }
    return self;
}

-(void)configUI:(GKDynamicModel*)model zanBlock:(void (^)(void))zanBlock pinglunBlock:(void (^)(void))pinglunBlock{
    [_topView configUI:model];
    self.contentLabel.text = model.content;
    
    [_linkView configUI:model];
    [_zanView configUI:model zanBlock:zanBlock pinglunBlock:pinglunBlock];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+(CGFloat)heightForModel:(GKDynamicModel*)model contentWidth:(CGFloat)width{
    CGFloat height = 60 + 10 + 10+60 + 50;
    
    UILabel *tmpLabel = [UILabel labelWithTitle:model.content fontSize:14 textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
    tmpLabel.numberOfLines = 0;
    tmpLabel.fm_width = width;
    [tmpLabel sizeToFit];
    
    return tmpLabel.fm_height + height;
}

-(void)layoutSubviews{
    self.contentLabel.fm_width = self.frame.size.width - 70;
    self.contentLabel.fm_leftTop = CGPointMake(70, _topView.fm_bottom + 10);
    [self.contentLabel sizeToFit];
    
    _linkView.fm_top = self.contentLabel.fm_bottom + 10;
    _zanView.fm_top = _linkView.fm_bottom;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
