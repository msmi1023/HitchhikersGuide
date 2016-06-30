//
//  MapViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "MapViewController.h"

@import GoogleMaps;

@interface MapViewController ()

@property (strong, nonatomic) CLLocation *myOrigin;
@property (strong, nonatomic) CLLocation *myDestination;

@end

@implementation MapViewController {
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
	NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	
	//NSString *googleApiKey = configuration[@"GoogleAPI"][@"GMSAPIKey"];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.3314
                                                            longitude:-83.0458
                                                                 zoom:10];

    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(42.3314, -83.0458);
    marker.title = @"Detroit";
    marker.snippet = @"Michigan";
    marker.map = mapView_;
    
    
    
    NSString *str=@"http://maps.googleapis.com/maps/api/directions/json?origin=440+Boroughs,Detroit,Michigan&destination=15575+Lundy+Pkwy,Dearborn,Michigan&sensor=false";
    NSURL *url=[[NSURL alloc]initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSData *data = [NSURLSession dataTaskWithRequest:request completionHandler:nil error:nil];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* latestRoutes = [json objectForKey:@"routes"];
    NSString *points=[[[latestRoutes objectAtIndex:0] objectForKey:@"overview_polyline"] objectForKey:@"points"];
    
    @try {
        // TODO: better parsing. Regular expression?
        NSArray *temp= [self decodePolyLine:[points mutableCopy]];
        GMSMutablePath *path = [GMSMutablePath path];
        for (int idx = 0; idx < [temp count]; idx++) {
            CLLocation *location=[temp objectAtIndex:idx];
            [path addCoordinate:location.coordinate];
        }
        // create the polyline based on the array of points.
        GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
        rectangle.strokeWidth=5.0;
        rectangle.map = mapView_;
    } @catch (NSException * e) {
        // TODO: show error
    }
       
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Draw Map paths

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init] ;
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5] ;
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5] ;
        printf("[%f,", [latitude doubleValue]);
        printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] ;
        [array addObject:loc];
    }
    
    return array;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
