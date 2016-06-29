//
//  Ride.h
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Ride : NSObject

@property (strong, nonatomic) NSString *startLocation;
@property (strong, nonatomic) NSString *endLocation;
@property (strong, nonatomic) NSDate *startDateTime;
@property (strong, nonatomic) NSDate *estimatedArivalTime;
@property (strong, nonatomic) User *driver;
@property (strong, nonatomic) NSMutableArray *riders;
@property BOOL friendsOnly;

-(NSArray *) getPaths;
-(int) numberOfSeatsRemaining;
-(void) cancelRideOffer;
-(void) removeUserFromRide;
-(void) addUserToRide;
-(id) initWithStartLocation:(NSString *)startLocation andEndLocation:(NSString *)endLocation andStartDateTime:(NSDate *)startDateTime andEstimatedArivalTime:(NSDate *)estimatedArivalTime andDriver:(User *)driver andRiders:(NSMutableArray *)riders andFriendsOnly:(BOOL)friendsOnly;

@end
