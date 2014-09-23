//
//  ToDoViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddActivityViewController.h"

@interface ToDoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblTodoactivitylist;
}
- (IBAction)AddActivity:(id)sender;

@end
