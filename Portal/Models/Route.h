//
//  Route.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum {
    Uber,
    Transit,
    Walking
} Mode;

@interface Route : MTLModel<MTLJSONSerializing>

+ (Mode)modeForString:(NSString *)string;

@property (nonatomic) NSNumber *duration;
@property (nonatomic) NSNumber *cost;
@property (nonatomic) NSArray *steps;
@property (nonatomic) NSArray *modes;

@end
