//
//  RootView.m
//  Portal
//
//  Created by Lucas Yan on 4/9/16.
//  Copyright © 2016 Lucas Yan. All rights reserved.
//

#import "API.h"
#import "AppStyle.h"
@import MBProgressHUD;
#import "RootView.h"
#import "Route.h"
#import "RouteTableViewCell.h"
#import "RouteTableViewCellView.h"
#import "StartEndTextView.h"
#import "Step.h"

@interface RootView ()

@property (nonatomic) StartEndTextView* startEndTextView;
@property (nonatomic) MKMapView* mapView;
@property (nonatomic) MKPointAnnotation *startPointAnnotation;
@property (nonatomic) MKPointAnnotation *endPointAnnotation;
@property (nonatomic) GMSPlace *startPlace;
@property (nonatomic) GMSPlace *endPlace;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSURLSessionDataTask *currentTask;
@property (nonatomic) NSArray *routes;
@property (nonatomic) Route *selectedRoute;
@property (nonatomic) UIView *divider;
@property (nonatomic) NSMutableArray *polylines;
@property (nonatomic) NSMutableArray *annotations;

@end

@implementation RootView

- (void)viewInit {
    [self setBackgroundColor:[AppStyle backgroundColor]];

    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    [self addSubview:self.mapView];

    self.polylines = [NSMutableArray new];
    self.annotations = [NSMutableArray new];

    self.tableView = [UITableView new];
    self.tableView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentOffset = CGPointMake(0, [RouteTableViewCellView cellMarginBottom]);
    self.tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];

    self.startEndTextView = [StartEndTextView new];
    self.startEndTextView.delegate = self;
    [self addSubview:self.startEndTextView];

    self.divider = [UIView new];
    self.divider.backgroundColor = [AppStyle lightGrayColor];
    [self addSubview:self.divider];

    __weak typeof(self) weakSelf = self;
    self.layout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
        CGFloat padding = 15;
        CGFloat startEndTextViewWidth = size.width - 2 * padding;
        CGFloat startEndTextViewHeight = [weakSelf.startEndTextView sizeThatFits:CGSizeMake(size.width - startEndTextViewWidth, 0)].height;
        [layout setFrame:CGRectMake(0, 0, size.width, size.height - startEndTextViewHeight - 2 * padding) view:weakSelf.mapView];
        [layout setFrame:CGRectMake(padding, size.height - startEndTextViewHeight - padding, startEndTextViewWidth, startEndTextViewHeight) view:weakSelf.startEndTextView];
        [layout setFrame:CGRectMake(0, 0, size.width, size.height - startEndTextViewHeight - 2 * padding) view:weakSelf.tableView];
        [layout setFrame:CGRectMake(0, size.height - startEndTextViewHeight - 2 * padding, size.width, 1) view:weakSelf.divider];
        return size;
    }];
}

- (void)route {
    if (self.currentTask) {
        [self.currentTask suspend];
    }
    if (self.startPlace && self.endPlace) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        self.mapView.userInteractionEnabled = NO;
        self.currentTask = [[API sharedManager] getRouteWithStart:self.startPlace.formattedAddress end:self.endPlace.formattedAddress success:^(NSArray *routes) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            self.routes = routes;
            [self showTableView];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            self.mapView.userInteractionEnabled = YES;
            [self.delegate rootViewShouldShowAlert:self withTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Unable to route", nil)];
        }];
    }
}

- (void)showTableView {
    self.tableView.alpha = 0;
    self.tableView.hidden = NO;
    self.mapView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.alpha = 1;
        self.mapView.alpha = 0;
    } completion:^(BOOL finished) {
        self.mapView.hidden = YES;
    }];
    [self.tableView reloadData];
}

- (void)hideTableView {
    self.mapView.alpha = 0;
    self.mapView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.alpha = 0;
        self.mapView.alpha = 1;
    } completion:^(BOOL finished) {
        self.tableView.hidden = YES;
        self.mapView.userInteractionEnabled = YES;
    }];
}

- (void)startEndTextViewStartTextTapped:(StartEndTextView *)startEndTextView {
    [self.delegate rootViewStartTextSelected:self];
}

- (void)startEndTextViewEndTextTapped:(StartEndTextView *)startEndTextView {
    [self.delegate rootViewEndTextSelected:self];
}

- (void)setStartPlace:(GMSPlace *)place {
    _startPlace = place;
    [self.startEndTextView setStartTextValue:place.formattedAddress];
    if (self.startPointAnnotation) {
        [self.mapView removeAnnotation:self.startPointAnnotation];
    }
    [self clearMapView];
    self.startPointAnnotation = [MKPointAnnotation new];
    self.startPointAnnotation.coordinate = place.coordinate;
    self.startPointAnnotation.title = NSLocalizedString(@"Start", nil);
    self.startPointAnnotation.subtitle = place.formattedAddress;
    [self.mapView addAnnotation:self.startPointAnnotation];
    [self hideTableView];
    [self zoomMap];
    [self route];
}

- (void)setEndPlace:(GMSPlace *)place {
    _endPlace = place;
    [self.startEndTextView setEndTextValue:place.formattedAddress];
    if (self.endPointAnnotation) {
        [self.mapView removeAnnotation:self.endPointAnnotation];
    }
    [self clearMapView];
    self.endPointAnnotation = [MKPointAnnotation new];
    self.endPointAnnotation.coordinate = place.coordinate;
    self.endPointAnnotation.title = NSLocalizedString(@"End", nil);
    self.endPointAnnotation.subtitle = place.formattedAddress;
    [self.mapView addAnnotation:self.endPointAnnotation];
    [self hideTableView];
    [self zoomMap];
    [self route];
}

- (void)zoomMap {
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annotationView.canShowCallout = YES;
    if ([annotation isEqual:self.startPointAnnotation]) {
        annotationView.pinTintColor = [MKPinAnnotationView greenPinColor];
    } else if ([annotation isEqual:self.endPointAnnotation]) {
        annotationView.pinTintColor = [MKPinAnnotationView redPinColor];
    } else {
        annotationView.pinTintColor = [MKPinAnnotationView purplePinColor];
    }
    return annotationView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCellIdentifier"];
    if (cell == nil) {
        cell = [[RouteTableViewCell alloc] init];
    }
    [cell configureWithRoute:self.routes[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setContentInset:UIEdgeInsetsMake([RouteTableViewCellView cellMarginBottom], 0, 0, 0)];
    return [self.routes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static RouteTableViewCell *cell;
    if (!cell) {
        cell = [[RouteTableViewCell alloc] init];
    }
    return [cell sizeThatFits:CGSizeMake(tableView.frame.size.width - 2 * 15, 0)].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRoute = self.routes[indexPath.row];
    for (Step *step in self.selectedRoute.steps) {
        for (NSString *polylineString in step.polylines) {
            MKPolyline *polyline = [RootView polylineWithEncodedString:polylineString];
            [self.mapView addOverlay:polyline];
            [self.polylines addObject:polyline];
        }
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(step.startLat.floatValue, step.startLong.floatValue);
        annotation.coordinate = coordinate;
        
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[step.startTime integerValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        annotation.title = [dateFormatter stringFromDate:startTime];
        annotation.subtitle = NSLocalizedString(step.readableString, nil);
        [self.mapView addAnnotation:annotation];
        [self.annotations addObject:annotation];
    }
    [self hideTableView];
}

- (void)clearMapView {
    [self.mapView removeOverlays:self.polylines];
    [self.mapView removeAnnotations:self.annotations];
    [self.polylines removeAllObjects];
    [self.annotations removeAllObjects];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 2;
        return routeRenderer;
    }
    else {
        return nil;
    }
}

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;

    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;

    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;

        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);

        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;

        shift = 0;
        res = 0;

        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);

        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;

        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;

        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;

        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }

    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    return polyline;
}

@end
