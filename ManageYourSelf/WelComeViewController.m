//
//  WelComeViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "WelComeViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"

@interface WelComeViewController ()
@end

@implementation WelComeViewController

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Welcome_bg"]]];

    //To set customize Login and Registration buttons
    [btnRegistration.layer setCornerRadius:10.0];
    btnRegistration.layer.borderColor = [UIColor whiteColor].CGColor;
    btnRegistration.layer.borderWidth = 1.0;
    btnRegistration.layer.masksToBounds = YES;
    [btnLogin.layer setCornerRadius:10.0];
    btnLogin.layer.borderColor = [UIColor whiteColor].CGColor;
    btnLogin.layer.borderWidth = 1.0;
    btnLogin.layer.masksToBounds = YES;

    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidLayoutSubviews {
    imgActivity.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    imgActivity.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login_Click:(id)sender {
    LoginViewController *loginView = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginView animated:YES];
}
- (IBAction)Registration_Click:(id)sender {
    RegistrationViewController *registerView = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self.navigationController pushViewController:registerView animated:YES];
}
@end
