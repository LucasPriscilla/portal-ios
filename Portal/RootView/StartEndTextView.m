//
//  StartEndTextView.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "StartEndTextView.h"
#import "AppStyle.h"
@import UIKit;

@interface StartEndTextView ()

@property (nonatomic) UILabel *startLabel;
@property (nonatomic) UILabel *startText;
@property (nonatomic) UILabel *endLabel;
@property (nonatomic) UILabel *endText;

@end

@implementation StartEndTextView

- (void)viewInit {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [AppStyle lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = NO;

    self.startLabel = [UILabel new];
    self.startLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    [self.startLabel setTextColor:[AppStyle lightTextColor]];
    [self.startLabel setText:NSLocalizedString(@"START", nil)];

    self.endLabel = [UILabel new];
    self.endLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    [self.endLabel setTextColor:[AppStyle lightTextColor]];
    [self.endLabel setText:NSLocalizedString(@"END", nil)];

    self.startText = [UILabel new];
    self.startText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    self.startText.userInteractionEnabled = YES;

    UITapGestureRecognizer *startTextTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTextTap)];
    [self.startText addGestureRecognizer:startTextTapGesture];

    self.endText = [UILabel new];
    self.endText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    self.endText.userInteractionEnabled = YES;

    UITapGestureRecognizer *endTextTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTextTap)];
    [self.endText addGestureRecognizer:endTextTapGesture];

    UIView *divider = [UIView new];
    [divider setBackgroundColor:[AppStyle lightGrayColor]];

    [self addSubview:self.startLabel];
    [self addSubview:self.endLabel];
    [self addSubview:self.startText];
    [self addSubview:self.endText];
    [self addSubview:divider];

    __weak typeof(self) weakSelf = self;
    self.layout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
        CGFloat sectionHeight = 50;
        CGFloat labelWidth = 40;
        CGFloat padding = 10;
        CGFloat textWidth = size.width - 3 * padding - labelWidth;
        CGFloat labelHeight = [weakSelf.startLabel sizeThatFits:CGSizeZero].height;
        CGFloat textHeight;
        if (![layout isSizing]) {
            UILabel *sampleText = [UILabel new];
            sampleText.font = weakSelf.startText.font;
            [sampleText setText:NSLocalizedString(@" ", nil)];
            textHeight = [sampleText sizeThatFits:CGSizeZero].height;
        }
        [layout setFrame:CGRectMake(padding, (sectionHeight - labelHeight) / 2, labelWidth, labelHeight) view:weakSelf.startLabel options:YOLayoutOptionsSizeToFitVertical];
        [layout setFrame:CGRectMake(padding, sectionHeight + (sectionHeight - labelHeight) / 2, labelWidth, labelHeight) view:weakSelf.endLabel options:YOLayoutOptionsSizeToFitVertical];
        [layout setFrame:CGRectMake(labelWidth + 2 * padding, (sectionHeight - textHeight) / 2, textWidth, textHeight) view:weakSelf.startText];
        [layout setFrame:CGRectMake(labelWidth + 2 * padding, sectionHeight + (sectionHeight - textHeight) / 2, textWidth, textHeight) view:weakSelf.endText];
        [layout setFrame:CGRectMake(0, sectionHeight, size.width, 1) view:divider];
        return CGSizeMake(size.width, 2 * sectionHeight);
    }];
}

- (void)startTextTap {
    [self.delegate startEndTextViewStartTextTapped:self];
}

- (void)endTextTap {
    [self.delegate startEndTextViewEndTextTapped:self];
}

- (void)setStartTextValue:(NSString *)text {
    self.startText.text = text;
}

- (void)setEndTextValue:(NSString *)text {
    self.endText.text = text;
}

@end
