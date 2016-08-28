//
//  RLCustomizer.h
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RLCustomizer : NSObject
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
