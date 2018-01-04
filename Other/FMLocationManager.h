//
//  FMLocationManager.h
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/23.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void(^fm_locationSuccessBlock)(CLLocation* location, AMapLocationReGeocode* geoCode);
typedef void(^fm_locationFailBlock)(NSError* error);

typedef void(^fm_authorizationFailBlock)(void);
typedef void(^fm_authorizationSuccBlock)(void);

@interface FMLocationManager : NSObject

@property (nonatomic, copy)NSString* city;
@property (nonatomic, assign)CLLocationCoordinate2D location;
@property (nonatomic, copy)fm_authorizationSuccBlock authorSuccBlock;
@property (nonatomic, copy)fm_authorizationFailBlock authorFailBlock;

+(instancetype)sharedManager;

+(BOOL)allowUpdatingLocation;

-(void)beginUpdatingLocation:(fm_locationSuccessBlock)successBlock locationFailBlock:(fm_locationFailBlock)failBlock;

-(void)doNavigationWithEndLocation:(NSArray *)endLocation atController:(UIViewController *)vc;

@end
