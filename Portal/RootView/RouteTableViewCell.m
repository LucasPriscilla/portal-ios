//
//  RouteTableViewCell.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "Route.h"
#import "RouteTableViewCell.h"
#import "RouteTableViewCellView.h"

@interface RouteTableViewCell ()

@property (nonatomic) RouteTableViewCellView *cellView;

@end

@implementation RouteTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cellView.frame = self.contentView.bounds;
}

- (void)configureWithRoute:(Route *)route {
    self.backgroundColor = [UIColor clearColor];
    [self.cellView configureWithRoute:route];
    self.cellView.frame = self.contentView.frame;
}

- (RouteTableViewCellView *)cellView {
    if (!_cellView) {
        _cellView = [RouteTableViewCellView new];
        [self.contentView addSubview:_cellView];
    }
    return _cellView;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.cellView sizeThatFits:size];
}

@end
