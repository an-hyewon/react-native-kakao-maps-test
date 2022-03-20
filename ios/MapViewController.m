#import "MapViewController.h"

@interface MapViewController () {
  MTMapView *_mapView;
}

@end


@implementation MapViewController

NSArray *createMarker(NSArray *markerList, NSString *markerImageUrl, NSString *markerImageName) {
  NSMutableArray *pointList = [[NSMutableArray alloc] init];

  for (NSDictionary *point in markerList) {
    MTMapPOIItem* item = [MTMapPOIItem poiItem];
    item.itemName = point[@"markerName"];
    item.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([point[@"lat"] doubleValue], [point[@"lng"] doubleValue])];
    item.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;

    item.markerType = markerImageUrl != nil || markerImageName != nil ? MTMapPOIItemMarkerTypeCustomImage : MTMapPOIItemMarkerTypeBluePin;

    if (markerImageUrl != nil) {
      item.customImage = [[[UIImage alloc] init] initWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: markerImageUrl]]];
    }
    if (markerImageName != nil) {
      item.customImageName = markerImageName;
    }
    
    [pointList addObject:item];
  }

  return pointList;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
  _mapView.delegate = self;
  _mapView.baseMapType = MTMapTypeStandard;

  double lat = [self.centerPoint[@"lat"] doubleValue];
  double lng = [self.centerPoint[@"lng"] doubleValue];

  [_mapView addPOIItems: createMarker(self.markerList, self.markerImageUrl, self.markerImageName)];
  [_mapView fitMapViewAreaToShowAllPOIItems];
  [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(lat, lng)] animated:YES];

  [self.view addSubview:_mapView];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_mapView != nil) {
        _mapView = nil;
    }
}

@end
