//
//  GKHomeController.m
//  FMGuoKongDianZhuang
//
//  Created by 范茂羽 on 2017/11/14.
//  Copyright © 2017年 范茂羽. All rights reserved.
//

#import "GKHomeController.h"
#import <MAMapKit/MAMapKit.h>
#import "GKDetailController.h"
#import "GKSearchController.h"
#import "FMLocationManager.h"
#import "GKPointAnnotation.h"
#import "GKStateModel.h"
#import "GKHomeBottomView.h"
#import "GKHomePushTransition.h"

@interface GKHomeController ()<MAMapViewDelegate, UINavigationControllerDelegate>
{
    MAMapView *_mapView;
    CLLocationCoordinate2D _curLocationCoor;
    BOOL _isLocating; //解决权限时好时坏问题
}
@property (nonatomic, strong)UIButton *cityBtn;
@property (nonatomic, strong)GKHomeBottomView *bottomView;
@property (nonatomic, copy)NSString* city;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation GKHomeController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

//覆写
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.fm_navigationBar.isHidden){
        [self hideTabBar:NO];
    }
}

-(UIView *)bottomView{
    if(_bottomView == nil){
        _bottomView = [[GKHomeBottomView alloc]initWithFrame:CGRectMake(0, self.view.fm_height, self.view.fm_width, 300)];
        [self.view addSubview:_bottomView];
    }
    
    return _bottomView;
}

-(void)createLeftView{
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cityBtn.frame = CGRectMake(0, 20, 60, 44);
    [self.cityBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [self.fm_navigationBar addSubview:self.cityBtn];
}

-(void)createRightView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.tag = 1007;
    rightBtn.frame = CGRectMake(self.fm_navigationBar.fm_width-60, 20, 60, 44);
    [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(MainTheme_Color) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fm_navigationBar addSubview:rightBtn];
}

-(void)createTitleView{
    UIView *view = [[UIView alloc]init];
    view.fm_size = CGSizeMake(self.fm_navigationBar.fm_width - 140, 30);
    view.center = CGPointMake(self.fm_navigationBar.fm_boundsCenter.x, self.fm_navigationBar.fm_boundsCenter.y + 10);
    [self.fm_navigationBar addSubview:view];
    view.layer.cornerRadius = view.fm_height / 2;
    view.layer.borderColor = [UIColor colorWithHex:0xCFCECE].CGColor;
    view.layer.borderWidth = .5f;
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeSystem];
    btn.tag = 1008;
    [btn setTitle:@"请输入目的地／电站名" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(LightText_Color) forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.frame = view.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    [btn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.fm_left = 10;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

-(void)searchBtnAction:(UIButton *)btn{
    GKSearchController *vc = [[GKSearchController alloc]init];
    if(btn.tag == 1007){
        vc.listArray = self.dataArray;
    }
    vc.cityName = self.city;
    vc.locationCoor = _curLocationCoor;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.showsCompass= NO;
    _mapView.rotateEnabled = NO;
    _mapView.rotateCameraEnabled = NO;
    [_mapView setZoomLevel:15.0f animated:YES];
    
    [self.view bringSubviewToFront:self.fm_navigationBar];
    
    WEAKSELf
    [FMLocationManager sharedManager].authorSuccBlock = ^{
        [weakSelf startLocation];
        _isLocating = YES;
    };
    
    [FMLocationManager sharedManager].authorFailBlock = ^{
        [FMDropToast showText:@"请您到\"设置\"中开启定位功能" atView:self.view offset:CGPointMake(0, 20)];

    };
    
    if([FMLocationManager allowUpdatingLocation] && !_isLocating){
        [weakSelf startLocation];
    }
}

//开始定位
-(void)startLocation{
    WEAKSELf
    [[FMLocationManager sharedManager]beginUpdatingLocation:^(CLLocation *location, AMapLocationReGeocode *geoCode) {
        _curLocationCoor = location.coordinate;
        [weakSelf.cityBtn setTitle:geoCode.city forState:UIControlStateNormal];
        weakSelf.city = geoCode.city;
        //定位成功，请求数据
        [weakSelf requestData];
    } locationFailBlock:^(NSError *error) {
        [FMDropToast showText:@"定位失败，请重试..." atView:self.view offset:CGPointMake(0, 20)];
    }];
}

#pragma mark -  MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }else if ([annotation isKindOfClass:[GKPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        
        GKPointAnnotation *myAnnotation = (GKPointAnnotation*)annotation;
        annotationView.image = [myAnnotation.stationModel.station_type integerValue] == 1?[UIImage imageNamed:@"zhanAnno"]:[UIImage imageNamed:@"zhuangAnno"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if(self.fm_navigationBar.isHidden){
        [self showTap];
    }else{
        [self closeTap];
    }
}


-(void)requestData{
    GKProgressHUD *hud = [GKProgressHUD showAtView:self.view];
    [[YLBNetworkingManager sharedManager]PostMethod:@"getStationList" parameters:@{@"user_id":[FMUserDefault objectForKey:@"user_id"], @"station_city":_city?_city:@"", @"station_lon":[NSString stringWithFormat:@"%.2f", _curLocationCoor.longitude], @"station_lat":[NSString stringWithFormat:@"%.2f", _curLocationCoor.latitude], @"search_key":@"", @"station_sort":@"1", @"station_filter":@"{}"} successBlock:^(id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]){
            id station_list = responseObject[@"station_list"];
            if([station_list isKindOfClass:[NSArray class]]){
                NSArray *array = station_list;
                [self.dataArray removeAllObjects];
                
                for(NSDictionary *dict in array){
                    GKStateModel *model = [[GKStateModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                    
                    GKPointAnnotation *pointAnnotation = [[GKPointAnnotation alloc] init];
                    pointAnnotation.stationModel = model;
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.station_lat floatValue], [model.station_lon floatValue]);
                    [_mapView addAnnotation:pointAnnotation];
                }
            }
        }
        
        [hud hideHUD];
    } failBlock:^(NSString *msg) {
        [hud hideHUD];
        [MBProgressHUD showText:msg to:self.view];
    }];
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    id<MAAnnotation> annotation = view.annotation;
    GKPointAnnotation *myAnnotation = annotation;
    CLLocationCoordinate2D location = annotation.coordinate;
    [mapView setCenterCoordinate:location animated:YES];
    [mapView setZoomLevel:15 animated:YES];
    
    [self hideBottomView];
    [self closeTap];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showBottomView:myAnnotation.stationModel];
    });

}

-(void)showTap{
    [self showNavigationBar:YES];
    [self showTabBar:YES];
}

-(void)closeTap{
    [self hideNavigationBar:YES];
    [self hideTabBar:YES];
}

-(void)showBottomView:(GKStateModel*)model{
    
    WEAKSELf
    [self.bottomView configUI:model leftBlock:^{
        GKDetailController *detailVC = [[GKDetailController alloc]init];
        detailVC.stationModel = model;
        [self.navigationController pushViewController:detailVC animated:YES];
    } rightBlock:^{
        if(model.station_lat && model.station_lon){
            [[FMLocationManager sharedManager]doNavigationWithEndLocation:@[model.station_lat, model.station_lon] atController:weakSelf];
        }
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        _mapView.fm_top = -100;
        self.bottomView.fm_bottom = self.view.fm_height;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideBottomView{
    [UIView animateWithDuration:0.3f animations:^{
        _mapView.fm_top = 0;
        self.bottomView.fm_top = self.view.fm_height;
    } completion:^(BOOL finished) {

    }];
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if([toVC isKindOfClass:[GKSearchController class]]){
        return [[GKHomePushTransition alloc]init];
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
