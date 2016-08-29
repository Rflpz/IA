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
- (void)getMoviesByCityWithID:(NSString *)cityID
                   onComplete:(void (^)(NSString *response))success
                       onError:(void (^)(NSString *error))error;
- (void)getMoviesFromDBWithPath:(NSString *)fileName
                     andIdPlace:(NSString *)idPlace
                     onComplete:(void (^)(NSMutableArray *response))successBlock
                        onError:(void (^)(NSString *error))errorBlock;
- (void)getPlacesFromDBWithPath:(NSString *)fileName
                     onComplete:(void (^)(NSMutableArray *response))successBlock
                        onError:(void (^)(NSString *error))errorBlock;

@end
