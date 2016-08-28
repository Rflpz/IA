//
//  RLMoviesController.m
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLMoviesController.h"

@interface RLMoviesController ()
@property (strong, nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;

@end

@implementation RLMoviesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _reqObj = [[RLRequest alloc] init];
//    [_reqObj getMoviesFromDBWithPath:_fileDB onComplete:^(NSMutableArray *response){
//        NSLog(@"%@",response);
//    } onError:^(NSString *error){
//        NSLog(@"%@",error);
//    }];
    [_reqObj getPlacesFromDBWithPath:_fileDB onComplete:^(NSMutableArray *response){
        NSLog(@"%@",response);
    } onError:^(NSString *error){
        NSLog(@"%@",error);
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
