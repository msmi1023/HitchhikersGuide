//
//  SearchViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFilters.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *dateTextfield;
@property (weak, nonatomic) IBOutlet UITextField *timeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *recurrenceTextfield;

@end



@implementation SearchViewController

SearchFilters *searchFilter1;






- (void)viewDidLoad {

    
    [super viewDidLoad];

    searchFilter1 = [SearchFilters initWithDestinationAddress:_addressTextfield.text andArrivalDate:_dateTextfield.text andArrivalTime:_timeTextfield.text andRecurrence:_recurrenceTextfield.text];

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
    
    NSLog(@"button pressed \n address: %@ \n date: %@ \n time : %@ \n recurrence:  %@  \n", _addressTextfield.text, _dateTextfield.text, _timeTextfield.text, _recurrenceTextfield.text);

}



@end
