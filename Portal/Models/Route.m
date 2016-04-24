//
//  Route.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "Route.h"
#import "Step.h"

@implementation Route

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"duration": @"duration",
        @"cost": @"cost",
        @"steps": @"steps",
        @"modes": @"modes"
             };
}

+ (NSValueTransformer *)stepsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Step.class];
}

+ (Mode)modeForString:(NSString *)string {
    if ([string isEqualToString:@"uber"]) {
        return Uber;
    } else if ([string isEqualToString:@"walking"]) {
        return Walking;
    } else {
        return Transit;
    }
}

@end
