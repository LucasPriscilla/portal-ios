//
//  Step.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Step : MTLModel<MTLJSONSerializing>

@property (nonatomic) NSArray *polylines;
@property (nonatomic) NSString *readableString;
@property (nonatomic) NSNumber *startLong;
@property (nonatomic) NSNumber *startLat;
@property (nonatomic) NSNumber *endLong;
@property (nonatomic) NSNumber *endLat;
@property (nonatomic) NSNumber *startTime;

@end
