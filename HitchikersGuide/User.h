//
//  User.h
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SearchFilters.h"


@interface User : NSObject

@property (strong, nonatomic) FBSDKAccessToken *token;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *vehicleType;
@property int totalNumberOfSeats;
@property (strong, nonatomic) NSMutableArray *openTrips;
@property (strong, nonatomic) NSMutableArray *openRides;
@property BOOL driverRole;
@property BOOL riderRole;
//@property (strong, nonatomic) SearchFilters *currentSearchFilters;
@property (strong, nonatomic) NSMutableDictionary *currentSearchFilters;

+(instancetype)getInstance;
-(void)setAccessToken:(FBSDKLoginManagerLoginResult *) loginResult;
-(void) offerRide;
-(void) joinRide;
//-(id) initWithToken:(FBSDKAccessToken *)token andUserName:(NSString *)userName andDisplayName:(NSString *)displayName andVehicleType:(NSString *)vehicleType andTotalNumberOfSeats:(int)totalNumberOfSeats andOpenTrips:(NSMutableArray *)openTrips andOpenRides:(NSMutableArray *)openRides andDriverRole:(BOOL)driverRole andriderRole:(BOOL)riderRole andCurrentSearchFilters:(SearchFilters *)currentSearchFilters;

@end
