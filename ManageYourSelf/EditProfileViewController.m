//
//  EditProfileViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "EditProfileViewController.h"
#define PortraitTextboxScrollingOffsetForExpandedIPhone5 90
#define PortraitTextboxScrollingOffsetForExpandedIPhone4 135

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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

    txtNewPassword.delegate = self;
    txtFirstName.delegate = self;
    txtLastName.delegate =self;
    txtPassword.delegate = self;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    //Set title to navitem
    self.navigationItem.title = @"User Info";
    
    //Tapgeature to hide Keyboard and revert scrollview position in tap of any view
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revertBackToOriginalView)];
    [self.view addGestureRecognizer:tapGeature];
    
    //To customize UpdateInfo button
    [btnUpdateinfo.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:153.0/255.0 alpha:1].CGColor];
    [btnUpdateinfo.layer setCornerRadius:5.0];
    [btnUpdateinfo.layer setBorderWidth:1.0];
    btnUpdateinfo.layer.masksToBounds = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self FillUserDetails];
}

-(void)viewDidLayoutSubviews {
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, [HelperMethods GetDeviceHeight])];
    scrollView.frame = CGRectMake(0, 0, [HelperMethods GetDeviceWidth], [HelperMethods GetDeviceHeight]  );
}

//To revert scrollview view position as before
-(void)revertBackToOriginalView {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

//Fill user details in textfield white editing
-(void)FillUserDetails {
    txtFirstName.text = [GeneralDeclaration generalDeclaration].currentUser.firstName;
    txtLastName.text = [GeneralDeclaration generalDeclaration].currentUser.lastName;
    
    if([GeneralDeclaration generalDeclaration].currentUser.gender == Male)
    {
        [segGender setSelectedSegmentIndex:Male];
    }
    else
    {
        [segGender setSelectedSegmentIndex:Female];
    }
}

- (IBAction)UpdateDetails_Click:(id)sender {
    [self revertBackToOriginalView];
    NSString *validationString = [self checkValidations];
    NSString *otherValidation = [self otherValidations];
    if([validationString length] == 0)
    {
        if([otherValidation length] == 0)
        {
            UserDetails *userInfo = [[UserDetails alloc]init];
            if([txtPassword.text length] > 0)
                userInfo.password = txtNewPassword.text;
            else
                userInfo.password = [GeneralDeclaration generalDeclaration].currentUser.password;
            userInfo.firstName = txtFirstName.text;
            userInfo.lastName = txtLastName.text;
            userInfo.userId = [GeneralDeclaration generalDeclaration].currentUser.userId;
            userInfo.email = [GeneralDeclaration generalDeclaration].currentUser.email;
            if(segGender.selectedSegmentIndex == Male)
                userInfo.gender = Male;
            else
                userInfo.gender = Female;
            int updatedUserId = [UserRepository UpdateUserInfo:userInfo];
            if(updatedUserId > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"Profile updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [txtPassword setText:@""];
                [txtNewPassword setText:@""];
                [GeneralDeclaration generalDeclaration].currentUser = [UserRepository GetUserInfoByUserId:(int)updatedUserId];

            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:otherValidation delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        validationString = [@"Following fields are required:\n" stringByAppendingString:validationString];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:validationString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

#pragma TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self revertBackToOriginalView];
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self scrollTextfield:textField];
    return YES;
}

//To check required field validations
-(NSString*)checkValidations {
    NSString *validationString = @"";
    if([txtFirstName.text length] == 0)
        validationString = @"FirstName";
    if([txtLastName.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"LastName"];
    }
    if([txtPassword.text length] > 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        if([txtNewPassword.text length] == 0)
        validationString = [validationString stringByAppendingString:@"NewPassword"];
    }
    else if([txtNewPassword.text length] > 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        if([txtPassword.text length] == 0)
            validationString = [validationString stringByAppendingString:@"Password"];
    }
    return validationString;
}

//To check other validation for Password length and current password
-(NSString*)otherValidations {
    NSString *validationString = @"";
    if([txtPassword.text length] > 0 && [txtNewPassword.text length] > 0)
    {
        if(![[GeneralDeclaration generalDeclaration].currentUser.password isEqualToString:txtPassword.text])
        {
            validationString = [validationString stringByAppendingString:@"Current password is wrong."];
        }
        
        if ([txtNewPassword.text length] < 6)
        {
            if ([validationString length] > 0)
                validationString = [validationString stringByAppendingString:@"\n"];
            validationString = [validationString stringByAppendingString:@"Please enter a newpassword with at least 6 characters."];
        }
    }
    return validationString;
}


//Log out Current Login User and Reset Shared objects for Current User
-(IBAction)logOutUser:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    [GeneralDeclaration generalDeclaration].currentUser = nil;
    WelComeViewController *welcomeVC = (WelComeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WelComeViewController"];
    [self.navigationController pushViewController:welcomeVC animated:YES];
}

#pragma Scroll Textfields on editing
-(void)scrollTextfield:(UITextField *)textField {
    float yOffset ;
    if (!IS_IPHONE_5) {
        yOffset = PortraitTextboxScrollingOffsetForExpandedIPhone4;
        CGPoint scrollPoint ;
        if(![textField isEqual:txtFirstName] && ![textField isEqual:txtLastName] )
        {
            scrollPoint = CGPointMake(0, textField.frame.origin.y + yOffset - 250);
            [scrollView setContentOffset:scrollPoint animated:YES];
        }
        else
        {
            [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
    }
    
}
@end
