//
//  RLRequest.h
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLRequest : NSObject
- (void)getAllCitiesOnComplete:(void (^)(NSDictionary *response))successBlock
                        onError:(void (^)(NSError *error))errorBlock;

@end
