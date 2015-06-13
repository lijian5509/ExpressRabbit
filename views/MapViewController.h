//
//  MapViewController.h
//  ExpressRabbit
//
//  Created by kuaiditu on 14-12-8.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "KuaiDiModel.h"
@protocol tranDistance <NSObject>

-(void)transDis:(NSString *)dis;

@end

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic,assign) float muBiao2La;
@property (nonatomic,assign) float muBiao2Long;
@property (nonatomic,copy) NSString *muBiaotitle;
@property (nonatomic,assign) id<tranDistance> delegate;

@end
