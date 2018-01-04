//
//  YLBPhotoWall.h
//  Yunlaoban
//
//  Created by 范茂羽 on 2017/10/28.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WallDirection){
    WALL_VERTICAL,
    WALL_HORIZONTAL,
};

typedef void (^AddPhotoBlock)(void);
typedef void (^DelPhotoBlock)(NSInteger index);

@interface YLBPhotoWall : UIView

@property (nonatomic, assign)CGFloat totalHeight;
@property (nonatomic, assign)NSInteger maxPicCount; //最大张数，默认5张
@property (nonatomic, assign)WallDirection direction; //布局方向

- (instancetype)initWithFrame:(CGRect)frame addBlock:(AddPhotoBlock)addBlock delBlock:(DelPhotoBlock)delBlock;

-(void)showData:(NSArray*)data;

@end
