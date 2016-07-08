//
//  MapViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "MapViewController.h"
#import "User.h"
#import "SearchFilters.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseAuth;
@import GoogleMaps;

@interface MapViewController ()

//@property (strong, nonatomic) CLLocation *myOrigin;
//@property (strong, nonatomic) CLLocation *myDestination;
//@property (strong, nonatomic) NSString *myOrigin;
//@property (strong, nonatomic) NSString *myDestination;
//@property double destLat;
//@property double destLong;

@end

@implementation MapViewController {
    GMSMapView *mapView_;
    FIRDatabaseReference *ref;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    ref = [[FIRDatabase database] reference];
    [self configureMap];
    [self getRidesForFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Draw Map paths

//-(void)getCurrentLocation {
//    
//}

-(void)configureMap {
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_destLat
//                                                            longitude:_destLong
//                                                                 zoom:10];
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

}

-(void)getRidesForFilters {
    
    FIRDatabaseQuery *destinationQuery = [[[ref child:@"rides"] queryOrderedByChild:@"endLocation"] queryEqualToValue:[User getInstance].currentSearchFilters[@"destinationAddress"] ];
    [destinationQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSLog(@"User UID = %@", [User getInstance].userName);
        NSLog(@"User filters = %@", [User getInstance].currentSearchFilters);
        NSLog(@"snapshot.exists = %hhd", snapshot.exists);
        
        if (snapshot.exists) {
            for (NSString *key in snapshot.value) {
                [self findPathForOrigin:snapshot.value[key][@"startLocation"] andDestination:snapshot.value[key][@"endLocation"]];
            }
        }
    }];
    
    //[self getOriginAndDestination];
    //[self drawMapPathWithOrigin:@"440 Boroughs, Detroit, Michigan, 48126" andDestination:@"15575 Lundy Pkwy, Dearborn, Michigan, 48126"];
    //[self convertAddressToLatLong];
}

-(void)findPathForOrigin:(NSString *)origin andDestination:(NSString *)destination {
    
    [self toLatLongForAddressString:origin andOnComplete:^(double origLat, double origLng){
        [self toLatLongForAddressString:destination andOnComplete:^(double destLat, double destLng){
            //NSLog(@"origin %@, destination %@, origLat %f, origLng %f, destLat %f, destLng %f", origin, destination, origLat, origLng, destLat, destLng);
            [self placePinsWithOrigLat:origLat andOrigLng:origLng andDestLat:destLat andDestLng:destLng];
            [self drawMapPathWithOrigin:origin andDestination:destination];
        }];
    }];
}

- (void)toLatLongForAddressString:(NSString *)address andOnComplete:(void(^)(double lat, double lng))callbackBlock {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error) {
        
        CLPlacemark *firstObj = [placemarks objectAtIndex:0];
        
        callbackBlock(firstObj.location.coordinate.latitude, firstObj.location.coordinate.longitude);
    }];
}

//-(void)getOriginAndDestination {
//    /***** myOrigin and myDestination will be retrieved values from filter in Firebase *****/
//    _myOrigin = @"440 Boroughs, Detroit, Michigan, 48202";
//    //_myDestination = @"15575 Lundy Pkwy, Dearborn, Michigan, 48126";
//    
//    _myDestination = [[User getInstance].currentSearchFilters objectForKey:@"destinationAddress"];
//    //_myDestination = [[User getInstance].currentSearchFilters.destinationAddress];
//}

-(void)placePinsWithOrigLat:(double)origLat andOrigLng:(double)origLng andDestLat:(double)destLat andDestLng:(double)destLng {
    
    // Creates a marker in the center of the map.
    GMSMarker *originMarker = [[GMSMarker alloc] init];
    GMSMarker *destMarker = [[GMSMarker alloc] init];
    originMarker.position = CLLocationCoordinate2DMake(origLat, origLng);
    destMarker.position = CLLocationCoordinate2DMake(destLat, destLng);
    //marker.title = _myDestination;
    originMarker.map = mapView_;
    destMarker.map = mapView_;
}

-(NSString *)formatAddressForURL:(NSString *)inputAddress {
    NSString *newString = [inputAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    newString = [newString stringByReplacingOccurrencesOfString:@",+" withString:@","];
    return newString;
}

//-(void)drawMapPathWithOrigin:(NSString *)origin andDestination:(NSString *)destination {
-(void)drawMapPathWithOrigin:(NSString *)origin andDestination:(NSString *)destination {
    
    origin = [self formatAddressForURL:origin];
    destination = [self formatAddressForURL:destination];
    
    //NSString *str=@"http://maps.googleapis.com/maps/api/directions/json?origin=440+Boroughs,Detroit,Michigan&destination=15575+Lundy+Pkwy,Dearborn,Michigan&sensor=false";
    NSString *str= [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false", origin, destination];
    
    //NSURL *url=[[NSURL alloc]initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url=[[NSURL alloc]initWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    //NSURL *url=[[NSURL alloc]initWithString:str];
                
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
        //printf("[%f,", [latitude doubleValue]);
        //printf("%f]", [longitude doubleValue]);
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
