//
//  LoginViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "LoginViewController.h"
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

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
	if (error == nil) {
		
		[self loginToFirebase:^(FIRUser *user){
			ref = [[FIRDatabase database] reference];
			
			//before we navigate, figure out the user object stuff in firebase
			
			[[ref child:@"filters"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
				NSLog(@"filters obj: %@", snapshot.value);
				
				if(snapshot.value[[user uid]] != nil) {
					//we have an object, use it
				}
				else {
					//no object, create one and use it
					NSDictionary *userObject = @{[user uid]: @{@"arrivalDate": @"", @"arrivalTime": @"", @"destinationAddress": @"", @"recurrence": @""}};
					
					[[ref child:@"filters"] updateChildValues:userObject];
				}
			} withCancelBlock:^(NSError * _Nonnull error) {
				NSLog(@"cancel block error: %@", error.localizedDescription);
			}];
			
			[self performSegueWithIdentifier:@"loginToHomeViewSegue" sender:loginButton];
		}];
		
	} else {
		NSLog(error.localizedDescription);
	}
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
	
}

- (void)loginToFirebase:(void(^)(FIRUser *user))callbackBlock {
	//grab token from the fb auth provider
	FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
	
	//then sign in to firebase with it
	[[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
		//and once we're in, goto the map view
		
		if(error == nil) {
			callbackBlock(user);
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
