//
//  GKBaoxiuTextViewCell.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/22.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKBaseCell.h"

@interface GKBaoxiuTextViewCell : GKBaseCell

@property (nonatomic, assign)BOOL canEdit;

-(void)configUI:(NSDictionary*)dict placeHolder:(NSString*)placeHolder ;

@end
