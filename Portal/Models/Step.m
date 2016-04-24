//
//  Step.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "Step.h"

@implementation Step

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"polylines": @"polyline",
        @"startLong": @"start_lng",
        @"startLat": @"start_lat",
        @"endLong": @"end_lng",
        @"endLat": @"end_lat",
        @"readableString": @"description",
        @"startTime": @"start_time"
             };
}

@end
