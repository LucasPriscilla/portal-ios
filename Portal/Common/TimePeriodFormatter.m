//
//  TimePeriodFormatter.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "TimePeriodFormatter.h"

@implementation TimePeriodFormatter
+ (NSString *)relativeTimeForDuration:(NSNumber *)seconds {
    NSInteger intSeconds = [seconds integerValue];
    if (intSeconds < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"%d sec", nil), intSeconds];
    } else if (intSeconds < 60 * 60) {
        NSInteger minutes = intSeconds / 60;
        return [NSString stringWithFormat:NSLocalizedString(@"%d min", nil), minutes];
    } else if (intSeconds < 60 * 60 * 24) {
        NSInteger hours = intSeconds / (60 * 60);
        NSInteger minutes = (intSeconds / 60) % 60;
        return [NSString stringWithFormat:NSLocalizedString(@"%d hr %d min", nil), hours, minutes];
    } else {
        NSInteger days = intSeconds / (60 * 60 * 24);
        NSInteger hours = intSeconds / (60 * 60) % 24;
        NSInteger minutes = (intSeconds / 60) % 60;
        return [NSString stringWithFormat:NSLocalizedString(@"%d d %d hr %d min", nil), days, hours, minutes];
    }
}
@end
