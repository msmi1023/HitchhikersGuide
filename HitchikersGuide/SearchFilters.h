//
//  SearchFilters.h
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface SearchFilters : NSObject

@property (strong, nonatomic) NSString *destinationAddress;
@property (strong, nonatomic) NSDate *arrivalDate;
@property (strong, nonatomic) NSDate *arrivalTime;
@property (strong, nonatomic) NSString *recurrence;

-(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence andFIRRef:(FIRDatabaseReference *) sref;
+(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence andFIRRef:(FIRDatabaseReference *)ref;
-(void)getFilterFromFIR:(FIRDatabaseReference *)ref;

@end
