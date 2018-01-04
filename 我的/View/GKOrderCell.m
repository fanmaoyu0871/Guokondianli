//
//  GKOrderCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/30.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKOrderCell.h"

@interface GKOrderCell()
{
    void (^_block)(void);
}
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *interfaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation GKOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.layer.cornerRadius = 5;
}

-(void)rightBtnAction{
    if(_block){
        _block();
    }
}

-(void)configUI:(GKDeviceModel*)model rightBlock:(void (^)(void))rightBlock{
    
    _block = rightBlock;
    
    self.orderLabel.text = model.device_port;
    self.timeLabel.text = model.time;
    self.longtimeLabel.text = model.duration;
    self.noLabel.text = model.device_code;
    self.typeLabel.text = model.device_type;
    self.interfaceLabel.text = model.device_interface;
    self.pwLabel.text = model.device_power;
    self.volLabel.text = model.device_voltage;
    self.powerLabel.text = model.device_source;
    
    [self.rightBtn setTitle:[model.order_type integerValue] == 1?@"查看评论":@"评价" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
