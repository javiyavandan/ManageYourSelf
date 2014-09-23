//
//  EditProfileViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRepository.h"
#import "WelComeViewController.h"

@interface EditProfileViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField* txtFirstName;
    IBOutlet UITextField* txtLastName;
    IBOutlet UITextField* txtNewPassword;
    IBOutlet UITextField* txtPassword;
    IBOutlet UISegmentedControl* segGender;
    IBOutlet UIButton* btnUpdateinfo;
    IBOutlet UIScrollView* scrollView;
}
- (IBAction)UpdateDetails_Click:(id)sender;
-(IBAction)logOutUser:(id)sender;
@end
