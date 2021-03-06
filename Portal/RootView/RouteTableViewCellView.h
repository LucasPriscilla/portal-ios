//
//  RouteTableViewCellView.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <YOLayout/YOLayout.h>

@class Route;

@interface RouteTableViewCellView : YOView

- (void)configureWithRoute:(Route *)route;
+ (CGFloat)cellMarginBottom;

@end
