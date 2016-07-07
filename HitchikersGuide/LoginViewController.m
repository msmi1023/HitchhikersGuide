//
//  LoginViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
//#import "SearchFilters.h"
@import Firebase;

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

FIRDatabaseReference *ref;

- (void)viewDidLoad {
	[super viewDidLoad];
	_loginButton = [[FBSDKLoginButton alloc]initWithFrame:CGRectZero];
	_loginButton.center = self.view.center;
	[self.view addSubview:_loginButton];
	[_loginButton setDelegate:self];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)createLoadingScreen {
	UIView *appLoadingView;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	appLoadingView = [[UIView alloc] initWithFrame:screenRect];
	[appLoadingView setBackgroundColor:[UIColor colorWithRed:0 green:0.508 blue:0.508 alpha:1]];
	
	[appLoadingView addSubview:[self createAppNameLabelForScreenRect:screenRect]];
	[appLoadingView addSubview:[self createLoadingTextLabelForScreenRect:screenRect]];
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
	[appLoadingView addSubview: activityIndicator];
	[activityIndicator startAnimating];
	
	return appLoadingView;
}

-(UILabel *)createAppNameLabelForScreenRect:(CGRect)screenRect {
	UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenRect.size.width/2)-150, 150, 300, 60)];
	appNameLabel.text = @"The Hitchhiker's Guide";
	appNameLabel.textColor = [UIColor whiteColor];
	
	[appNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
	
	appNameLabel.textAlignment = NSTextAlignmentCenter;
	
	return appNameLabel;
}

-(UILabel *)createLoadingTextLabelForScreenRect:(CGRect)screenRect {
	UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenRect.size.width/2)-150, 350, 300, 60)];
	appNameLabel.text = @"Loading...";
	appNameLabel.textColor = [UIColor whiteColor];
	appNameLabel.textAlignment = NSTextAlignmentCenter;
	
	return appNameLabel;
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
	if (error == nil) {
		
		
		[self.view addSubview:[self createLoadingScreen]];
		
		[self loginToFirebase:^(FIRUser *user){
			ref = [[FIRDatabase database] reference];
			
			//before we navigate, figure out the user object stuff in firebase
			[[ref child:@"filters"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
				NSMutableDictionary *filterObject;
                //SearchFilters *filterObject = [[SearchFilters alloc]init];
                
                //NSLog(@"[user uid] = %@", [user uid]);
				
				if(snapshot.value[[user uid]] == nil) {
					//no object, create an empty one and push to firebase
					filterObject = [@{[user uid]: @{@"arrivalDate": [NSDate date], @"arrivalTime": [NSDate date], @"destinationAddress": @"", @"recurrence": @""}} mutableCopy];
                    
                    //[filterObject initWithDestinationAddress:@"" andArrivalDate:nil andArrivalTime:nil andRecurrence:@"" andFIRRef:(FIRDatabaseReference *)ref];
					[[ref child:@"filters"] updateChildValues:filterObject];
				}
				else {
					//use the current one
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat: @"yyyy:MM:dd"];
                    
					filterObject = [snapshot.value[[user uid]] mutableCopy];
                    filterObject[@"arrivalDate"] = [dateFormatter dateFromString:filterObject[@"arrivalDate"]];
                    filterObject[@"arrivalTime"] = [dateFormatter dateFromString:filterObject[@"arrivalTime"]];
				}
				
				//do something to put user object into app memory here, once models are ready
                [[User getInstance]setAccessToken:result];
                if ([User getInstance]) {
                    //[User getInstance].userName;
                    [User getInstance].displayName = user.displayName;
                    //[User getInstance].vehicleType;
                    //[User getInstance].totalNumberOfSeats;
                    //[User getInstance].openTrips;
                    //[User getInstance].openRides;
                    //[User getInstance].driverRole;
                    //[User getInstance].riderRole;
                    [User getInstance].currentSearchFilters = filterObject;
                }
				
				[self performSegueWithIdentifier:@"loginToHomeViewSegue" sender:loginButton];
			} withCancelBlock:^(NSError * _Nonnull error) {
				NSLog(@"cancel block error: %@", error.localizedDescription);
			}];
		}];
		
	} else {
		NSLog(error.localizedDescription);
	}
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
	
	NSError *error;
	[[FIRAuth auth] signOut:&error];
	if (!error) {
		NSLog(@"Signed out successfully.");
	}
	
}

- (void)loginToFirebase:(void(^)(FIRUser *user))callbackBlock {
	//grab token from the fb auth provider
	FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
	
	//then sign in to firebase with it
	[[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
		if(error == nil) {
			//add in a force refresh to help mitigate issues with firebase not responding
			[user getTokenForcingRefresh:YES completion:^(NSString *token, NSError *error){
				callbackBlock(user);
			}];
		}
		else {
			NSLog(error.localizedDescription);
		}
	}];
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
