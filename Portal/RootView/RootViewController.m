//
//  RootViewController.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "RootViewController.h"
@import YOLayout;
@import GoogleMaps;

typedef enum {
    None,
    StartText,
    EndText
} RootViewInputState;

@interface RootViewController ()
@property (nonatomic) RootView *rootView;
@property (nonatomic) RootViewInputState inputState;
@end

@implementation RootViewController

- (void)loadView {
    self.inputState = None;
    self.rootView = [RootView new];
    self.rootView.delegate = self;
    self.view = self.rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)rootViewStartTextSelected:(RootView *)rootView {
    self.inputState = StartText;
    [self showAutoCompleteView];
}

-(void)rootViewEndTextSelected:(RootView *)rootView {
    self.inputState = EndText;
    [self showAutoCompleteView];
}

-(void)showAutoCompleteView {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.inputState == StartText) {
        [self.rootView setStartPlace:place];
    } else {
        [self.rootView setEndPlace:place];
    }
    self.inputState = None;
}

-(void)rootViewShouldShowAlert:(RootView *)rootView withTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
