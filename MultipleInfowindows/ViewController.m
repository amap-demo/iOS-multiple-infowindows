//
//  ViewController.m
//  MultipleInfowindows
//
//  Created by xiaoming han on 16/11/18.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "MAInfowindowView.h"
#import "POIAnnotation.h"

#define kAPIKey @"dd622ce72744125b6b54199ad5d711e3"

@interface ViewController ()<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation ViewController

#pragma mark - Utility

- (void)searchPoiKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.city = @"北京";
    request.offset = 20;
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    AMapPOI *poi = ((POIAnnotation *)view.annotation).poi;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"InfoWindowView" message:poi.name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
    NSLog(@"poi :%@, address :%@", poi.name, poi.address);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAInfowindowView *poiAnnotationView = (MAInfowindowView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAInfowindowView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            
            // 屏蔽默认的calloutView
            poiAnnotationView.canShowCallout = NO;
        }
        
        POIAnnotation *poiAnno = (POIAnnotation *)annotation;
        poiAnnotationView.title = poiAnno.poi.name;
        poiAnnotationView.accessibilityIdentifier = @"CustomInfoWindowView";
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        POIAnnotation *anno = [[POIAnnotation alloc] initWithPOI:obj];
        [poiAnnotations addObject:anno];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = kAPIKey;
    
    [self initSearch];
    [self initMapView];
    
}

#pragma mark xib btn click

- (IBAction)start:(id)sender {
    [self searchPoiKeyword:@"肯德基"];
}


@end
