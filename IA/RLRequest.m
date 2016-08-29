//
//  RLRequest.m
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLRequest.h"
#import "AFNetworking.h"
#import <FMDatabase.h>

static NSString *const BASE_URL_API_CINEPOLIS = @"http://api.cinepolis.com.mx/";

static NSString *const METHOD_GET_CITIES = @"Consumo.svc/json/ObtenerCiudades";
static NSString *const METHOD_GET_MOVIES_BY_CITY = @"sqlite.aspx?idCiudad=";
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

- (void)getMoviesByCityWithID:(NSString *)cityID
                   onComplete:(void (^)(NSString *response))success
                      onError:(void (^)(NSString *error))error{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API_CINEPOLIS,METHOD_GET_MOVIES_BY_CITY,cityID];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData ){
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[NSString stringWithFormat:@"db-%@.sqlite",cityID]];
        success(filePath);
        [urlData writeToFile:filePath atomically:YES];
    }else{
        error(@"No data content");
    }
}
- (void)getMoviesFromDBWithPath:(NSString *)fileName
                     andIdPlace:(NSString *)idPlace
                     onComplete:(void (^)(NSMutableArray *response))successBlock
                        onError:(void (^)(NSString *error))errorBlock{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:fileName];
    FMDatabase *db = [FMDatabase databaseWithPath:pathDB];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM Pelicula INNER JOIN Cartelera ON (Pelicula.Id == Cartelera.IdPelicula AND Cartelera.IdComplejo = %@) GROUP BY Pelicula.Id",idPlace]];
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        while ([s next]) {
            NSMutableDictionary *movie = [[NSMutableDictionary alloc] init];
            [movie setObject:[s stringForColumn:@"Titulo"] forKey:@"Titulo"];
            [movie setObject:[s stringForColumn:@"IdPelicula"] forKey:@"Id"];
            [movie setObject:[s stringForColumn:@"Genero"] forKey:@"Genero"];
            [movie setObject:[s stringForColumn:@"Clasificacion"] forKey:@"Clasificacion"];
            [movie setObject:[s stringForColumn:@"Director"] forKey:@"Director"];
            [movie setObject:[s stringForColumn:@"Sinopsis"] forKey:@"Sinopsis"];
            [movie setObject:[s stringForColumn:@"Actores"] forKey:@"Actores"];

            [movies addObject:movie];
        }
        successBlock(movies);
    }else{
        errorBlock(@"The file name can't be loaded");
    }

}

- (void)getPlacesFromDBWithPath:(NSString *)fileName
                     onComplete:(void (^)(NSMutableArray *response))successBlock
                        onError:(void (^)(NSString *error))errorBlock{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:fileName];
    FMDatabase *db = [FMDatabase databaseWithPath:pathDB];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM Complejo"];
        NSMutableArray *places = [[NSMutableArray alloc] init];
        while ([s next]) {
            NSMutableDictionary *place = [[NSMutableDictionary alloc] init];
            [place setObject:[s stringForColumn:@"Nombre"] forKey:@"Nombre"];
            [place setObject:[s stringForColumn:@"Id"] forKey:@"Id"];
            [place setObject:[s stringForColumn:@"Direccion"] forKey:@"Direccion"];
            [place setObject:[s stringForColumn:@"Latitud"] forKey:@"Latitud"];
            [place setObject:[s stringForColumn:@"Longitud"] forKey:@"Longitud"];
            [place setObject:[s stringForColumn:@"Telefono"] forKey:@"Telefono"];
            [places addObject:place];
        }
        successBlock(places);
    }else{
        errorBlock(@"The file name can't be loaded");
    }
    
}
- (void)getImagesOfMovieFromDBWithPath:(NSString *)fileName
                           withIdImage:(NSString *)imageId
                            onComplete:(void (^)(NSMutableArray *response))successBlock
                               onError:(void (^)(NSString *error))errorBlock{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathDB = [documentsDirectory stringByAppendingPathComponent:fileName];
    FMDatabase *db = [FMDatabase databaseWithPath:pathDB];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM  Multimedia WHERE Multimedia.IdPelicula = %@  ",imageId]];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        while ([s next]) {
            NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
            [image setObject:[s stringForColumn:@"Tipo"] forKey:@"Tipo"];
            if([[s stringForColumn:@"Tipo"] isEqualToString:@"Imagen"]){
                [image setObject:[s stringForColumn:@"Archivo"] forKey:@"Archivo"];
                [images addObject:image];

            }
        }
        successBlock(images);
    }else{
        errorBlock(@"The file name can't be loaded");
    }

}
@end
