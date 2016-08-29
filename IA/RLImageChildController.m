//
//  RLImageChildController.m
//  IA
//
//  Created by Rafael Lopez on 8/29/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLImageChildController.h"
#import "UIImageView+AFNetworking.h"

@interface RLImageChildController ()

@end

@implementation RLImageChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imgBack setImageWithURL:[NSURL URLWithString:_URL] placeholderImage:[UIImage imageNamed:@"earth.png"]];
}


@end
