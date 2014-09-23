//
//  AddActivityViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetails.h"
#import "ActivityRepository.h"

@interface AddActivityViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtDescription;
    IBOutlet UITextField *txtStartDate;
    IBOutlet UILabel *lblCompetition;
    IBOutlet UITextField *txtfinishDate;
    IBOutlet UISwitch *swCompetition;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *btnAddupdate;
}
- (IBAction)AddActivity_CLick:(id)sender;

@property (nonatomic,retain) ActivityDetails *activityInfo;
@end
