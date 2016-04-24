//
//  TimePeriodFormatter.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimePeriodFormatter : NSObject
+ (NSString *)relativeTimeForDuration:(NSNumber *)seconds;
@end
