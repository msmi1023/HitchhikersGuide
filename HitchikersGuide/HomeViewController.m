//
//  MapViewController.m
//  HitchikersGuide
//
//  Created by tstone10 on 6/28/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

UIView *instructionCoverView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	// get your window screen size
	[self configureInstructionPopup];
}

- (void)configureInstructionPopup {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	instructionCoverView = [[UIView alloc] initWithFrame:screenRect];
	[instructionCoverView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
	
	[instructionCoverView addSubview:[self createInstructionHintViewForScreenRect:screenRect]];
	[[instructionCoverView layer] addSublayer:[self createShapeLayer]];
	
	[self.view addSubview:instructionCoverView];
	
}

-(CAShapeLayer *)createShapeLayer {
	CGPoint origin = CGPointMake(80, 125);
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(origin.x, origin.y)];
	[path addLineToPoint:CGPointMake(origin.x-10, origin.y+15)];
	[path addLineToPoint:CGPointMake(origin.x+10, origin.y+15)];
	[path closePath];
	[path fill];
	
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = path.CGPath;
	shapeLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
	
	return shapeLayer;
}

-(UIView *)createInstructionHintViewForScreenRect:(CGRect)screenRect {
	UIView *instructionHint = [[UIView alloc] initWithFrame:CGRectMake(40, 140, screenRect.size.width-80, 120)];
	[instructionHint setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
	instructionHint.layer.cornerRadius = 5;
	instructionHint.layer.masksToBounds = YES;
	
	[instructionHint addSubview:[self createInstructionTextLabelForScreenRect:screenRect]];
	
	[instructionHint addSubview:[self createInstructionDismissButtonForScreenRect:screenRect]];
	
	return instructionHint;
}

-(UILabel *)createInstructionTextLabelForScreenRect:(CGRect)screenRect {
	UILabel *instructionTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(((screenRect.size.width-80)/2)-100, 0, 200, 60)];
	instructionTextLabel.text = @"Blank map?\nTry tapping Search/Filter!";
	instructionTextLabel.textColor = [UIColor whiteColor];
	[instructionTextLabel setNumberOfLines: 0];
	//instructionTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	instructionTextLabel.textAlignment = NSTextAlignmentCenter;
	
	return instructionTextLabel;
}

-(UIButton *)createInstructionDismissButtonForScreenRect:(CGRect)screenRect {
	UIButton *instructionDismissButton = [[UIButton alloc] initWithFrame:CGRectMake(((screenRect.size.width-80)/2)-30, 65, 60, 40)];
	
	[instructionDismissButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
	[instructionDismissButton setTitle:@"Got it!" forState:UIControlStateNormal];
	
	[[instructionDismissButton layer] setBorderWidth:1.0f];
	[[instructionDismissButton layer] setBorderColor:[UIColor whiteColor].CGColor];
	
	[instructionDismissButton addTarget:self
								 action:@selector(instructionDismissPressed)
					   forControlEvents:UIControlEventTouchUpInside];

	return instructionDismissButton;
}

- (void)instructionDismissPressed {
	[instructionCoverView removeFromSuperview];
};

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

-(IBAction)unwindToHomeView:(UIStoryboardSegue *)unwindSegue {
	
}

@end
