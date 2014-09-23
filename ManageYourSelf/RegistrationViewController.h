//
//  RegistrationViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRepository.h"
#import "TabViewController.h"

@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField* txtFirstName;
    IBOutlet UITextField* txtLastName;
    IBOutlet UITextField* txtEmail;
    IBOutlet UITextField* txtPassword;
    IBOutlet UISegmentedControl* segGender;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton* btnRegister;
}
- (IBAction)Registration_Click:(id)sender;
@end
