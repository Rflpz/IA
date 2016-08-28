//
//  RLMoviesController.m
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLMoviesController.h"
#import "RLRequest.h"
@interface RLMoviesController ()
@property (strong, nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;
@end

@implementation RLMoviesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _reqObj = [[RLRequest alloc] init];
    [_reqObj getAllCitiesOnComplete:^(NSDictionary *response){
        NSLog(@"%@",response);
    } onError:^(NSError *error){}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

@end
