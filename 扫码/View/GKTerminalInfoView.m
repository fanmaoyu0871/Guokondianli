//
//  GKTerminalInfoView.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/25.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKTerminalInfoView.h"

@interface GKTerminalInfoView()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *noLabel;
@end

@implementation GKTerminalInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HEXCOLOR(0xffffff);
        
        UILabel *label = [UILabel labelWithTitle:@"终端信息" fontSize:16.0f textColor:HEXCOLOR(NormalText_Color) textWeight:UIFontWeightRegular];
        label.fm_leftTop = CGPointMake(10, 10);
        [self addSubview:label];
        
        UIView *line = [[UIView alloc]initWithBackgroundColor:HEXCOLOR(TableBackground_Color)];
        line.fm_size = CGSizeMake(frame.size.width, 1);
        line.fm_leftTop = CGPointMake(0, label.fm_bottom + 10);
        [self addSubview:line];
        
        UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"terminalname"]];
        [self addSubview:topImageView];
        topImageView.fm_leftTop = CGPointMake(10, line.fm_bottom + 10);
        
        self.nameLabel = [UILabel labelWithTitle:@"--" fontSize:14 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:self.nameLabel];
        self.nameLabel.fm_left = topImageView.fm_right + 10;
        self.nameLabel.fm_centerY = topImageView.fm_centerY;
        
        UIImageView *downImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"terminalNo"]];
        [self addSubview:downImageView];
        downImageView.fm_leftTop = CGPointMake(10, topImageView.fm_bottom + 20);
        
        self.noLabel = [UILabel labelWithTitle:@"--" fontSize:14 textColor:HEXCOLOR(LightText_Color) textWeight:UIFontWeightRegular];
        [self addSubview:self.noLabel];
        self.noLabel.fm_left = downImageView.fm_right + 10;
        self.noLabel.fm_centerY = downImageView.fm_centerY;
    }
    return self;
}

-(void)configName:(NSString*)name no:(NSString*)no{
    self.nameLabel.text = name;
    self.noLabel.text = no;
    
    [self.nameLabel sizeToFit];
    [self.noLabel sizeToFit];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
