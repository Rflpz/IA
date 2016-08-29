//
//  RLMapPlaceController.h
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class RLMapPlaceController;
@protocol RLMapPlaceDelegate <NSObject>
- (void)didSelectShowRoute:(RLMapPlaceController *)controller;
@end
@interface RLMapPlaceController : UIViewController
@property (weak, nonatomic) id <RLMapPlaceDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *placesArray;
@property BOOL showAll;
@property (strong, nonatomic) NSString *myLat, *myLon;

@end
