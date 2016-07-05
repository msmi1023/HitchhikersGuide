//
//  SearchFilters.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/29/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SearchFilters.h"

@implementation SearchFilters

-(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence{
    
    self = [super init];
    if (self){
        _destinationAddress = destinationAddress;
        _arrivalDate = arrivalDate;
        _arrivalTime = arrivalTime;
        _recurrence = recurrence;
    }
    return self;
}


+(id)initWithDestinationAddress:(NSString *)destinationAddress andArrivalDate:(NSDate *)arrivalDate andArrivalTime:(NSDate *)arrivalTime andRecurrence:(NSString *)recurrence{
    return [[super alloc] initWithDestinationAddress:destinationAddress andArrivalDate:arrivalDate andArrivalTime:arrivalTime andRecurrence:recurrence];
    
}






@end
