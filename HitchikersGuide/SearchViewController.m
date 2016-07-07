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

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *recurrenceTextfield;

@end


@implementation SearchViewController

SearchFilters *searchFilter1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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


- (IBAction)saveChangesButton:(id)sender {
    [User getInstance].currentSearchFilters =  @{@"arrivalDate":[_datePicker date], @"arrivalTime":[_timePicker date], @"destinationAddress":_addressTextfield.text, @"recurrence":_recurrenceTextfield.text};
    
    //searchFilter1 = [SearchFilters initWithDestinationAddress:_addressTextfield.text andArrivalDate:[_datePicker date] andArrivalTime:[_timePicker date] andRecurrence:_recurrenceTextfield.text];

//    This NSLog is to check the values of the filters as assigned to it.
//    NSLog(@"button pressed \n address: %@ \n date: %@ \n time : %@ \n recurrence:  %@  \n", searchFilter1.destinationAddress, searchFilter1.arrivalDate, searchFilter1.arrivalTime, searchFilter1.recurrence);
    
}


@end
