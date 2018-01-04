//
//  GKDynamicCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/17.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"
#import "GKDynamicModel.h"

@interface GKDynamicCell : GKBaseCell

-(void)configLeft:(id)obj right:(NSString*)rightString image:(UIImage*)image;

+(CGFloat)heightForZanModel:(GKDynamicModel*)model;

+(CGFloat)heightForPinglunDict:(NSDictionary*)dict;

@end
