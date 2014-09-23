//
//  WelComeViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelComeViewController : UIViewController
{
    IBOutlet UIImageView *imgActivity;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnRegistration;
}
- (IBAction)Login_Click:(id)sender;
- (IBAction)Registration_Click:(id)sender;

@end

