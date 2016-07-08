//
//  SearchViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SearchViewController.h"
//#import "SearchFilters.h"
#import "User.h"
@import Firebase;
@import FirebaseDatabase;
@import FirebaseAuth;

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;

@end


@implementation SearchViewController {
    FIRDatabaseReference *ref;
}

SearchFilters *searchFilter1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //need function to populate filters with current user data
    ref = [[FIRDatabase database] reference];
    
    [self populateUserFilterValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)populateUserFilterValues {
    
    [_datePicker setDate:[[User getInstance].currentSearchFilters objectForKey:@"arrivalDate"]];
    [_timePicker setDate:[[User getInstance].currentSearchFilters objectForKey:@"arrivalTime"]];
    _addressTextfield.text = [[User getInstance].currentSearchFilters objectForKey:@"destinationAddress"];
}


- (IBAction)saveChangesButton:(id)sender {
    [User getInstance].currentSearchFilters =  [@{@"arrivalDate":[_datePicker date], @"arrivalTime":[_timePicker date], @"destinationAddress":_addressTextfield.text} mutableCopy];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy:MM:dd:HH:mm:ss"];
    ref = [[FIRDatabase database] reference];
    NSDictionary *filterObject = [@{[User getInstance].userName:
                              @{@"arrivalDate" : [dateFormatter stringFromDate:_datePicker.date],
                                @"arrivalTime" : [dateFormatter stringFromDate:_datePicker.date],
                         @"destinationAddress" : _addressTextfield.text
    }} mutableCopy];
    [[ref child:@"filters"] updateChildValues:filterObject];    
    
    
    //searchFilter1 = [SearchFilters initWithDestinationAddress:_addressTextfield.text andArrivalDate:[_datePicker date] andArrivalTime:[_timePicker date] andRecurrence:_recurrenceTextfield.text];

//    This NSLog is to check the values of the filters as assigned to it.
//    NSLog(@"button pressed \n address: %@ \n date: %@ \n time : %@ \n recurrence:  %@  \n", searchFilter1.destinationAddress, searchFilter1.arrivalDate, searchFilter1.arrivalTime, searchFilter1.recurrence);
    
}


@end
