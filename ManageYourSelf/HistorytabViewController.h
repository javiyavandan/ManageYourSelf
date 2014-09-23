//
//  HistorytabViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityRepository.h"
#import "ActivityDetails.h"
#import "AddActivityViewController.h"

@interface HistorytabViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView* tblHistoryData;
}

@end
