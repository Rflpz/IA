//
//  RLMapPlaceController.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLMapPlaceController.h"
#define SPAN 0.09f

@interface RLMapPlaceController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRoute;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property bool isInitial;
@end

@implementation RLMapPlaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_showAll) {
        _btnRoute.hidden = _showAll;
    }
    [self paintAnnotationsOverMap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    _isInitial = false;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ((oldLocation.coordinate.latitude != 0.0) && (oldLocation.coordinate.longitude != 0.0)) {
        [self.locationManager stopUpdatingLocation];
        if (!_isInitial) {
            _myLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            _myLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            _isInitial = true;
        }
    }
}
- (void)paintAnnotationsOverMap{
    for(NSDictionary *place in _placesArray){
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationDegrees currentLatitude = [[place valueForKey:@"Latitud"] doubleValue];
        CLLocationDegrees currentLongitude = [[place valueForKey:@"Longitud"] doubleValue];
        point.coordinate =  CLLocationCoordinate2DMake(currentLatitude, currentLongitude);
        point.title = [place valueForKey:@"Nombre"];
        point.subtitle = [NSString stringWithFormat:@"%@\n%@",[place valueForKey:@"Direccion"],[place valueForKey:@"Telefono"]];
        [_map addAnnotation:point];
    }
    MKCoordinateRegion myRegion;
    
    double lat = [[_placesArray[_placesArray.count-1] valueForKey:@"Latitud"] doubleValue];
    double lon = [[_placesArray[_placesArray.count-1] valueForKey:@"Longitud"] doubleValue];
    CLLocationCoordinate2D center;
    center.latitude = lat;
    center.longitude = lon;
    
    MKCoordinateSpan span;
    span.latitudeDelta = SPAN;
    span.longitudeDelta = SPAN;
    
    myRegion.center = center;
    myRegion.span = span;
    
    [self.map setRegion:myRegion animated:YES];
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showRoute:(id)sender {
    [_delegate didSelectShowRoute:self];
}



@end
