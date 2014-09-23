//
//  SplashScreenViewController.m
//  Health Manager App
//
//  Created by Milan Saraiya on 03/06/13.
//  Copyright (c) 2013 Beurer. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
        [self.lblLoadapp setFrame:CGRectMake(self.lblLoadapp.frame.origin.x,[HelperMethods GetDeviceHeight]/2 + [HelperMethods GetDeviceHeight]/4, self.lblLoadapp.frame.size.width,self.lblLoadapp.frame.size.height)];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end
