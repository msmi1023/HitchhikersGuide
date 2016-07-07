//
//  SearchFilters.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SearchFilters.h"

@implementation SearchFilters

-(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence andFIRRef:(FIRDatabaseReference *)ref{
    
    self = [super init];
    if (self){
        _destinationAddress = destinationAddress;
        _arrivalDate = arrivalDate;
        _arrivalTime = arrivalTime;
        _recurrence = recurrence;
    }
    if ([_destinationAddress isEqual:@""]) {
        [self setFilterInFIR:(FIRDatabaseReference *)ref];
    }
    return self;
}

+(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence andFIRRef:(FIRDatabaseReference *)ref{
    return [[super alloc] initWithDestinationAddress:destinationAddress andArrivalDate:arrivalDate andArrivalTime:arrivalTime andRecurrence:recurrence andFIRRef:ref];
    
}

-(void)setFilterInFIR:(FIRDatabaseReference *)ref {
    
    
    //[[ref child:@"filters"] updateChildValues:filterObject];
}

-(void)getFilterFromFIR:(FIRDatabaseReference *)ref {
    
    
}

@end
