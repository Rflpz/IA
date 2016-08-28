//
//  RLRequest.m
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLRequest.h"
#import "AFNetworking.h"

static NSString *const BASE_URL_API_CINEPOLIS = @"http://api.cinepolis.com.mx/";

static NSString *const METHOD_GET_CITIES = @"Consumo.svc/json/ObtenerCiudades";


@implementation RLRequest
- (void)getAllCitiesOnComplete:(void (^)(NSDictionary *response))successBlock
                       onError:(void (^)(NSError *error))errorBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@",BASE_URL_API_CINEPOLIS,METHOD_GET_CITIES] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            NSDictionary *responseData;
            NSError *error = nil;
            if (responseObject != nil) {
                responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
            }
            if (!responseData) {
                NSLog(@"Error to parse json.");
            }else{
                successBlock(responseData);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
}
@end
