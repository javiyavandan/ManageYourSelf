//
//  AddActivityViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "AddActivityViewController.h"

#define PortraitTextboxScrollingOffsetForExpandedIPhone5 90
#define PortraitTextboxScrollingOffsetForExpandedIPhone4 110

@interface AddActivityViewController ()

@end

@implementation AddActivityViewController
{
    UIDatePicker *startdatePicker;
    UIDatePicker *enddatePicker;
    NSDate *selectedStartDate;
    NSDate *selectedEndDate;
    ActivityDetails *activityDetails;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    //Set Background Image
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    txtTitle.delegate = self;
    txtDescription.delegate = self;
    txtStartDate.delegate =self;
    txtfinishDate.delegate = self;
    
    [self Initialization];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//Intialization Required fields
-(void)Initialization {
    //To customize Update button
    [btnAddupdate.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:153.0/255.0 alpha:1].CGColor];
    [btnAddupdate.layer setCornerRadius:5.0];
    [btnAddupdate.layer setBorderWidth:1.0];
    btnAddupdate.layer.masksToBounds = YES;
    
    //Set Tag to textfield for Datepickers
    txtStartDate.tag = 10;
    txtfinishDate.tag = 11;
    
    //Tapgeature to hide Keyboard and revert scrollview position in tap of any view
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revertBackToOriginalView)];
    [self.view addGestureRecognizer:tapGeature];
}

//To check required field validations
-(void)revertBackToOriginalView {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

//On Change of values in Startdate datepicker
-(void)changeStartDate:(id)sender {
    selectedStartDate = [(UIDatePicker *)sender date];
	txtStartDate.text = [HelperMethods convertDateToString:selectedStartDate];
    //startdatePicker.date = [HelperMethods convertStringToDate:txtStartDate.text];
}

//On Change of values in Enddate datepicker
-(void)changeEndDate:(id)sender {
    selectedEndDate = [(UIDatePicker *)sender date];
	txtfinishDate.text = [HelperMethods convertDateToString:selectedEndDate];
}

-(void)viewDidAppear:(BOOL)animated {
    //Set Text field values in editing mode
    if(self.activityInfo.activityId > 0)
    {
        txtTitle.text =self.activityInfo.activityTitle;
        txtDescription.text = self.activityInfo.description;
        txtStartDate.text = [HelperMethods convertDateToString:self.activityInfo.startDate];
        txtfinishDate.text = [HelperMethods convertDateToString:self.activityInfo.finishDate];
        [swCompetition setHidden:NO];
        [lblCompetition setHidden:NO];
        if(self.activityInfo.completionFlag)
            [swCompetition setOn:YES];
        else
            [swCompetition setOn:NO];
        activityDetails = self.activityInfo;
        self.navigationItem.title = @"Update Activity";
        [btnAddupdate setTitle:@"Update Activity" forState:UIControlStateNormal];
    }
    //TO set values for add activity
    else
    {
        [swCompetition setHidden:YES];
        [lblCompetition setHidden:YES];
        self.navigationItem.title = @"Add Activity";
        activityDetails = [[ActivityDetails alloc]init];
        [btnAddupdate setTitle:@"Add Activity" forState:UIControlStateNormal];
    }
}

-(void)viewDidLayoutSubviews {
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, [HelperMethods GetDeviceHeight])];
    scrollView.frame = CGRectMake(0, 0, [HelperMethods GetDeviceWidth], [HelperMethods GetDeviceHeight]  );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Initialization datepicker for Text field
-(UIDatePicker *)GetDatePicker:(int)Tag SelectedDate:(NSDate *)SelectedDate {
    
//    if(Tag == 10)
//        startdatePicker = [[UIDatePicker alloc]init];
//    else
        startdatePicker = [[UIDatePicker alloc]init];
    startdatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_GB"];
    startdatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //datePicker.date = [NSDate date];
    //long long truncedDate = [datePicker.date timeIntervalSinceReferenceDate];
    //truncedDate /= 60;
    //truncedDate *= 60;
    //datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:truncedDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:startdatePicker.date];
    NSInteger hour = [dateComponents hour];
    
    
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents1 = [gregorian1 components:(NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]]; //[NSDate date] is the current date
    [dateComponents1 setHour:hour];
    [dateComponents1 setMinute:0];
    [dateComponents1 setSecond:0];
    NSDate *newDate = [gregorian1 dateFromComponents:dateComponents1];
    
    startdatePicker.date = SelectedDate;
    startdatePicker.minimumDate = [NSDate date];
    startdatePicker.tag = Tag;
    if(Tag == 10)
        [startdatePicker addTarget:self action:@selector(changeStartDate:) forControlEvents:UIControlEventValueChanged];
    else
        [startdatePicker addTarget:self action:@selector(changeEndDate:) forControlEvents:UIControlEventValueChanged];
    return startdatePicker;
}

- (IBAction)AddActivity_CLick:(id)sender {
    [self revertBackToOriginalView];
    NSString *validationString = [self checkValidations];
    NSString *otherValidation = [self otherValidations];
    if([validationString length] == 0)
    {
        if([otherValidation length] == 0)
        {
            ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
            activityInfo.activityTitle = txtTitle.text;
            activityInfo.description = txtDescription.text;
            activityInfo.startDate = [HelperMethods convertStringToDate:txtStartDate.text];
            activityInfo.finishDate = [HelperMethods convertStringToDate:txtfinishDate.text];
            activityInfo.userId = [GeneralDeclaration generalDeclaration].currentUser.userId;

            int activityId = 0;
            if(activityDetails.activityId > 0)
            {
                if(!swCompetition.isOn)
                    activityInfo.completionFlag = 0;
                else
                    activityInfo.completionFlag = 1;
                activityInfo.activityId = activityDetails.activityId;
                activityId = [ActivityRepository Updatenewactivity:activityInfo];
            }
            else
            {
                activityInfo.completionFlag = 0;
                
                activityId =  [ActivityRepository Insertnewactivity:activityInfo];
            }
            if(activityId == activityInfo.activityId)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"Activity updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (activityId > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"Activity created successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isEqual:txtTitle] || [textField isEqual:txtDescription])
    {
        [scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    }

    if ([textField isEqual:txtStartDate]) {
        UIToolbar *toolbar = [HelperMethods GetToolbarWithDoneButton:textField.tag ParentViewController:self];
        NSDate *selectedDate = [NSDate date];
        if(activityDetails.activityId > 0)
            selectedDate = activityDetails.startDate;
        else if ([txtStartDate.text length]>0)
            selectedDate = [HelperMethods convertStringToDate:txtStartDate.text];
        UIDatePicker *datepicker =  [self GetDatePicker:txtStartDate.tag SelectedDate:selectedDate ];
        txtStartDate.text = [HelperMethods convertDateToString:selectedDate];
        textField.inputView = datepicker;
        textField.inputAccessoryView = toolbar;
    }
    if ([textField isEqual:txtfinishDate]) {
        UIToolbar *toolbar = [HelperMethods GetToolbarWithDoneButton:textField.tag ParentViewController:self];
        NSDate *selectedDate = [NSDate date];
        if(activityDetails.activityId > 0)
            selectedDate = activityDetails.finishDate;
        else if ([txtfinishDate.text length]>0)
            selectedDate = [HelperMethods convertStringToDate:txtfinishDate.text];
        UIDatePicker *datepicker =  [self GetDatePicker:txtfinishDate.tag SelectedDate:selectedDate ];
        txtfinishDate.text = [HelperMethods convertDateToString:selectedDate];
        textField.inputView = datepicker;
        textField.inputAccessoryView = toolbar;
    }
    [self scrollTextfield:textField];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self revertBackToOriginalView];
    return [textField resignFirstResponder];
}

#pragma Toolbar Methods for cancel and done button clicks
-(void)doneButtonPressed:(id)sender  {
    if([sender tag] == 10)
    {
        [txtStartDate resignFirstResponder];
        [txtfinishDate becomeFirstResponder];
    }
    else
    {
        [self revertBackToOriginalView];
        [txtfinishDate resignFirstResponder];
    }
}

-(void)cancelButtonPressed:(id)sender {
    [self revertBackToOriginalView];
    [txtStartDate resignFirstResponder];
    [txtfinishDate resignFirstResponder];
}

#pragma Alertview Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//To check required field validations
-(NSString*)checkValidations {
    NSString *validationString = @"";
    if([txtTitle.text length] == 0)
        validationString = @"ActivityTitle";
    if([txtDescription.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"Description"];
    }
    if([txtStartDate.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"StartDate"];
    }
    if([txtfinishDate.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"FinishDate"];
    }
    return validationString;
}

//To check other validation for start date and finish date difference
-(NSString*)otherValidations {
    NSString *validationString = @"";
    if([txtStartDate.text length] > 0 && [txtfinishDate.text length] > 0)
    {
        NSDate *startDate = [HelperMethods convertStringToDate:txtStartDate.text];
        NSDate *finishDate = [HelperMethods convertStringToDate:txtfinishDate.text];
        if([startDate compare:finishDate] != NSOrderedAscending)
        {
            validationString = @"Finsihdate must be greater then Startdate.";
        }
        
    }
    return validationString;
}

#pragma Scroll Textfields on editing
-(void)scrollTextfield:(UITextField *)textField {
    float yOffset ;
    if (!IS_IPHONE_5) {
        yOffset = PortraitTextboxScrollingOffsetForExpandedIPhone4;
    }
    else
    {
        yOffset = PortraitTextboxScrollingOffsetForExpandedIPhone5;
    }
    
    CGPoint scrollPoint ;
    if(![textField isEqual:txtTitle] && ![textField isEqual:txtDescription] )
    {
        scrollPoint = CGPointMake(0, textField.frame.origin.y + yOffset - 250);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}
@end
