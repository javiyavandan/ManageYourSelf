//
//  RegistrationViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "RegistrationViewController.h"

#define PortraitTextboxScrollingOffsetForExpandedIPhone5 90
#define PortraitTextboxScrollingOffsetForExpandedIPhone4 135

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

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
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    txtEmail.delegate = self;
    txtFirstName.delegate = self;
    txtLastName.delegate =self;
    txtPassword.delegate = self;
    
    //Tapgeature to hide Keyboard and revert scrollview position in tap of any view
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revertBackToOriginalView)];
    [self.view addGestureRecognizer:tapGeature];
    
    //To customize Registration button
    [btnRegister.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:153.0/255.0 alpha:1].CGColor];
    [btnRegister.layer setCornerRadius:5.0];
    [btnRegister.layer setBorderWidth:1.0];
    btnRegister.layer.masksToBounds = YES;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [self.navigationController setNavigationBarHidden:NO];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, [HelperMethods GetDeviceHeight])];
    scrollView.frame = CGRectMake(0, 0, [HelperMethods GetDeviceWidth], [HelperMethods GetDeviceHeight]  );
}

//To revert scrollview view position as before
-(void)revertBackToOriginalView {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (IBAction)Registration_Click:(id)sender {
    NSString *validationString = [self checkValidations];
    NSString *otherValidations = [self otherValidations];
    if([validationString length] == 0)
    {
        if([otherValidations length] == 0)
        {
            NSString *email = txtEmail.text;
            int userId = [UserRepository CheckUserExists:email];
            if(userId > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"User with same email exists.Please check your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UserDetails *userInfo = [[UserDetails alloc]init];
                userInfo.email = email;
                userInfo.password = txtPassword.text;
                userInfo.firstName = txtFirstName.text;
                userInfo.lastName = txtLastName.text;
                if(segGender.selectedSegmentIndex == Male)
                    userInfo.gender = Male;
                else
                    userInfo.gender = Female;
                int insertedUserId = [UserRepository InsertUserInfo:userInfo];
                if(insertedUserId > 0)
                {
                    [GeneralDeclaration generalDeclaration].currentUser = [UserRepository GetUserInfoByUserId:(int)insertedUserId];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"User created successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:otherValidations delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

#pragma Alertview Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        TabViewController *tabViewVC = (TabViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
        [self.navigationController pushViewController:tabViewVC animated:YES];
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
    if([txtEmail.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"E-mail"];
    }
    if([txtPassword.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"Password"];
    }
    return validationString;
}

//To check other validation for Email address format and Password length
- (NSString *)otherValidations {
    NSString *otherValidations = @"";
    if ([txtEmail.text length] > 0 && ![HelperMethods IsValidEmail:txtEmail.text Strict:NO])
        otherValidations = @"Please enter a valid E-Mail address.";
    
    if (([txtPassword.text length] > 0) && ([txtPassword.text length] < 6))
    {
        if ([otherValidations length] > 0)
            otherValidations = [otherValidations stringByAppendingString:@"\n"];
        otherValidations = [otherValidations stringByAppendingString:@"Please enter a password with at least 6 characters."];
    }
    return otherValidations;
}

#pragma Scroll Textfields on editing
-(void)scrollTextfield:(UITextField *)textField
{
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
