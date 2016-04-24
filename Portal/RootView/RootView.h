//
//  RootView.h
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

@import GoogleMaps;
@import MapKit;
#import "StartEndTextView.h"
@import UIKit;
@import YOLayout;

@class StartEndTextView;
@class RootView;

@protocol RootViewDelegate

-(void)rootViewStartTextSelected:(RootView *)rootView;
-(void)rootViewEndTextSelected:(RootView *)rootView;
-(void)rootViewShouldShowAlert:(RootView *)rootView withTitle:(NSString *)title message:(NSString *)message;

@end

@interface RootView : YOView <StartEndTextViewDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)setStartPlace:(GMSPlace *)place;
- (void)setEndPlace:(GMSPlace *)place;

@property (weak, nonatomic) id<RootViewDelegate> delegate;

@end

