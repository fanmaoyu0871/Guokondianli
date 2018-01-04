//
//  GKBaoxiuCell.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaoxiuCell.h"

@interface GKBaoxiuCell()
{
    void (^_block)(NSInteger flag);
}
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *interfaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation GKBaoxiuCell

-(void)configUI:(GKDeviceModel*)model block:(void (^)(NSInteger index))block{
    self.leftNoLabel.text = model.device_port;
    self.noLabel.text = model.device_code;
    self.typeLabel.text = model.device_type;
    self.interfaceLabel.text = model.device_interface;
    self.pwLabel.text = model.device_power;
    self.volLabel.text = model.device_voltage;
    self.powerLabel.text = model.device_source;
    
    [self.rightBtn setTitle:[model.device_status integerValue]==1?@"报修":@"已报修" forState:UIControlStateNormal];
    
    _block = block;
}
- (IBAction)baoxiuBtnAction:(UIButton*)sender {
    if(_block){
        _block([sender.currentTitle isEqualToString:@"报修"]?1:2);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftNoLabel.layer.cornerRadius = 2;
    self.leftNoLabel.layer.borderWidth = 1;
    self.leftNoLabel.layer.borderColor = [UIColor colorWithHex:MainTheme_Color].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
