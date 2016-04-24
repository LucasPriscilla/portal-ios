//
//  SessionManager.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

@import AFNetworking;

@interface SessionManager : AFHTTPSessionManager

+ (id)sharedManager;

@end
