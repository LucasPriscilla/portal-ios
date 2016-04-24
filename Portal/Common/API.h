//
//  API.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "SessionManager.h"

@interface API : SessionManager

- (NSURLSessionDataTask *)getRouteWithStart:(NSString *)startDescription
                                        end:(NSString *)endDescription
                                    success:(void (^)(NSArray *routes))success
                                    failure:(void (^)(NSError *error))failure;

@end
