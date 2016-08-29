//
//  RLImageChildController.h
//  IA
//
//  Created by Rafael Lopez on 8/29/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLImageChildController : UIViewController
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;
@end
