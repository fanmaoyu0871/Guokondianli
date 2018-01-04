//
//  GKPersonalCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/20.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"

@interface GKPersonalCell : GKBaseCell
-(void)configLeftTitle:(NSString*)leftTitle leftImage:(UIImage*)leftImage rightTitle:(NSString*)rightTitle rightImage:(UIImage*)rightImage;

-(void)hideRightArrow:(BOOL)isHide;

@end
