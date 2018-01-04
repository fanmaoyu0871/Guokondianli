//
//  GKSimpleCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/26.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"

@interface GKSimpleCell : GKBaseCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

-(void)configLeftTitle:(NSString*)leftTitle rightTitle:(NSString*)rightTitle;

@end
