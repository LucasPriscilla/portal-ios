//
//  RouteTableViewCellView.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "AppStyle.h"
#import "Route.h"
#import "RouteTableViewCellView.h"
#import "TimePeriodFormatter.h"

static const CGFloat CELL_MARGIN_BOTTOM = 20;

@interface RouteTableViewCellView ()

@property UIView *backgroundView;
@property UILabel *durationLabel;
@property UILabel *priceLabel;
@property UIImageView *iconRight;
@property UIImageView *iconMiddle;
@property UIImageView *iconLeft;

@end

@implementation RouteTableViewCellView

- (void)viewInit {
    self.backgroundColor = [UIColor clearColor];

    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.layer.borderColor = [AppStyle lightGrayColor].CGColor;
    self.backgroundView.layer.borderWidth = 1;
    self.backgroundView.layer.cornerRadius = 2;

    self.durationLabel = [UILabel new];
    self.durationLabel.textColor = [AppStyle darkTextColor];
    self.durationLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20];

    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = [AppStyle darkTextColor];
    self.priceLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:16];

    self.iconRight = [UIImageView new];
    self.iconMiddle = [UIImageView new];
    self.iconLeft = [UIImageView new];

    [self addSubview:self.backgroundView];
    [self addSubview:self.durationLabel];
    [self addSubview:self.priceLabel];

    [self addSubview:self.iconRight];
    [self addSubview:self.iconMiddle];
    [self addSubview:self.iconLeft];

    __weak typeof(self) weakSelf = self;
    self.layout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
        CGFloat padding = 20;
        CGFloat iconSize = 30;

        CGFloat y = padding;

        CGFloat x = size.width - padding;
        x -= padding;
        x -= iconSize;
        CGFloat iconRightX = x;
        x -= padding;
        x -= iconSize;
        CGFloat iconMiddleX = x;
        x -= padding;
        x -= iconSize;
        CGFloat iconLeftX = x;
        x -= padding;
        CGFloat iconY = (size.height - iconSize - CELL_MARGIN_BOTTOM) / 2;

        CGFloat durationLabelHeight;
        CGFloat priceLabelHeight;

        UILabel *sampleText = [UILabel new];
        sampleText.font = weakSelf.durationLabel.font;
        [sampleText setText:NSLocalizedString(@" ", nil)];
        durationLabelHeight = [sampleText sizeThatFits:CGSizeZero].height;
        sampleText.font = weakSelf.priceLabel.font;
        priceLabelHeight = [sampleText sizeThatFits:CGSizeZero].height;

        y += [layout setFrame:CGRectMake(2 * padding, y, x - 2 * padding, durationLabelHeight) view:weakSelf.durationLabel].size.height;
        y += padding / 2;
        y += [layout setFrame:CGRectMake(2 * padding, y, x - 2 * padding, priceLabelHeight) view:weakSelf.priceLabel].size.height;
        y += padding;

        [layout setFrame:CGRectMake(iconRightX, iconY, iconSize, iconSize) view:weakSelf.iconRight];
        [layout setFrame:CGRectMake(iconMiddleX, iconY, iconSize, iconSize) view:weakSelf.iconMiddle];
        [layout setFrame:CGRectMake(iconLeftX, iconY, iconSize, iconSize) view:weakSelf.iconLeft];
        [layout setFrame:CGRectMake(padding, 0, size.width - 2 * padding, y) view:weakSelf.backgroundView];

        return CGSizeMake(size.width, y + CELL_MARGIN_BOTTOM);
    }];
}

- (void)configureWithRoute:(Route *)route {
    [self.durationLabel setText:[TimePeriodFormatter relativeTimeForDuration:route.duration]];
    [self.priceLabel setText:[NSString stringWithFormat:@"$%.2f", route.cost.floatValue]];
    NSArray *flattenedArray = [[NSOrderedSet orderedSetWithArray:route.modes] array];
    if ([flattenedArray count] > 0) {
        [self.iconRight setImage:[self getIconForMode:[Route modeForString:route.modes[0]]]];
        self.iconRight.hidden = NO;
    } else {
        self.iconRight.hidden = YES;
    }

    if ([flattenedArray count] > 1) {
        [self.iconMiddle setImage:[self getIconForMode:[Route modeForString:route.modes[1]]]];
        self.iconMiddle.hidden = NO;
    } else {
        self.iconMiddle.hidden = YES;
    }

    if ([flattenedArray count] > 2) {
        [self.iconLeft setImage:[self getIconForMode:[Route modeForString:route.modes[2]]]];
        self.iconLeft.hidden = NO;
    } else {
        self.iconLeft.hidden = YES;
    }
}

- (UIImage *)getIconForMode:(Mode)mode {
    switch (mode) {
        case Uber:
            return [UIImage imageNamed:@"uber.png"];
        case Walking:
            return [UIImage imageNamed:@"walking.png"];
        case Transit:
        default:
            return [UIImage imageNamed:@"bus.png"];
    }
}

+ (CGFloat)cellMarginBottom {
    return CELL_MARGIN_BOTTOM;
}

@end
