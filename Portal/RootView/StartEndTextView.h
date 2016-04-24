//
//  StartEndTextView.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import <YOLayout/YOLayout.h>

@class StartEndTextView;

@protocol StartEndTextViewDelegate

- (void)startEndTextViewStartTextTapped:(StartEndTextView *)startEndTextView;
- (void)startEndTextViewEndTextTapped:(StartEndTextView *)startEndTextView;

@end

@interface StartEndTextView : YOView

- (void)setStartTextValue:(NSString *)text;
- (void)setEndTextValue:(NSString *)text;

@property (weak, nonatomic) id<StartEndTextViewDelegate> delegate;

@end
