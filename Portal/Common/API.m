//
//  API.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "API.h"
#import "Route.h"

@implementation API

- (NSURLSessionDataTask *)getRouteWithStart:(NSString *)startDescription
                                        end:(NSString *)endDescription
                                    success:(void (^)(NSArray *routes))success
                                    failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{
                                 @"from": startDescription,
                                 @"to": endDescription
                                 };
    return [self GET:@"/api/v1/route" parameters:parameters
            progress: nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray *results = [MTLJSONAdapter modelsOfClass:Route.class fromJSONArray:responseArray error:&error];
                 success(results);
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 failure(error);
             }];
}

@end
