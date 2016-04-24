//
//  SessionManager.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "Config.h"
#import "SessionManager.h"

@implementation SessionManager

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    if (!self) {
        return nil;
    }

    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];

    return self;
}

+ (id)sharedManager {
    static SessionManager *_sessionManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });

    return _sessionManager;
}

@end
