//
//  RouteTableViewCell.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Route;

@interface RouteTableViewCell : UITableViewCell

- (void)configureWithRoute:(Route *)route;

@end
