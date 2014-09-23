//
//  ToDoViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "ToDoViewController.h"

@interface ToDoViewController ()

@end

@implementation ToDoViewController
{
    NSMutableArray *todayActivityData;
    NSMutableArray *incompleteActivityData;
    NSMutableArray *futureActivityData;
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
    //Set navigation title
    [self.navigationItem setTitle:@"To Do"];
    
    todayActivityData = [[NSMutableArray alloc]init];
    incompleteActivityData = [[NSMutableArray alloc]init];
    futureActivityData = [[NSMutableArray alloc]init];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Get all date from database for all sections
    todayActivityData = [ActivityRepository GetallactivitiesbyuserId:[GeneralDeclaration generalDeclaration].currentUser.userId];
    
    incompleteActivityData = [ActivityRepository GetallIncompleteActivityDetails:[GeneralDeclaration generalDeclaration].currentUser.userId];
    
    futureActivityData =[ActivityRepository GetallfutureactivitiesbyuserId:[GeneralDeclaration generalDeclaration].currentUser.userId];

    [tblTodoactivitylist reloadData];
}

-(void)viewDidLayoutSubviews {
    [tblTodoactivitylist setFrame:CGRectMake(0, 5, [HelperMethods GetDeviceWidth], [HelperMethods GetDeviceHeight] - 54)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview Delegate
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
    {
        return @"Today's Activities";
    }
    else if(section == 1)
    {
        return @"Incomplete Activities";
    }
    else
    {
        return @"Future Activities";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    {
            return [todayActivityData count];
    }
    else if (section == 1)
    {
            return [incompleteActivityData count];
    }
    else
    {
            return [futureActivityData count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    ActivityDetails *activityInfo =[[ActivityDetails alloc]init];
    if(indexPath.section == 0)
    {
        if([todayActivityData count] > 0)
        {
            activityInfo=(ActivityDetails*)[todayActivityData objectAtIndex:indexPath.row];
            
        }
    }
    else if (indexPath.section == 1)
    {
        if([incompleteActivityData count] > 0)
        {
            activityInfo=(ActivityDetails*)[incompleteActivityData objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if([futureActivityData count] > 0)
        {
            activityInfo=(ActivityDetails*)[futureActivityData objectAtIndex:indexPath.row];

        }
    }
    cell.textLabel.text = activityInfo.activityTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   -   %@",[HelperMethods convertDateToString:activityInfo.startDate],[HelperMethods convertDateToString:activityInfo.finishDate]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
    if(indexPath.section == 0)
    {
        if([todayActivityData count] > 0)
        {
            activityInfo = (ActivityDetails*)[todayActivityData objectAtIndex:indexPath.row];
        }
    }
    else if(indexPath.section == 1)
    {
        if([incompleteActivityData count] > 0)
        {
            activityInfo = (ActivityDetails*)[incompleteActivityData objectAtIndex:indexPath.row];

        }
    }
    else
    {
        if([futureActivityData count] > 0)
        {
            activityInfo = (ActivityDetails*)[futureActivityData objectAtIndex:indexPath.row];

        }
    }

    AddActivityViewController *addActivityVC = (AddActivityViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddActivityViewController"];
    addActivityVC.activityInfo = activityInfo;
    [self.navigationController pushViewController:addActivityVC animated:YES];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        if(indexPath.section == 0)
        {
            ActivityDetails *activityInfo = [todayActivityData objectAtIndex:indexPath.row];
            activityInfo.isDeleted = YES;
            [ActivityRepository Updatenewactivity:activityInfo];
            [todayActivityData removeObjectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1)
        {
            ActivityDetails *activityInfo = [incompleteActivityData objectAtIndex:indexPath.row];
            activityInfo.isDeleted = YES;
            [ActivityRepository Updatenewactivity:activityInfo];
            [incompleteActivityData removeObjectAtIndex:indexPath.row];
        }
        else
        {
            ActivityDetails *activityInfo = [futureActivityData objectAtIndex:indexPath.row];
            activityInfo.isDeleted = YES;
            [ActivityRepository Updatenewactivity:activityInfo];
            [futureActivityData removeObjectAtIndex:indexPath.row];
        }

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)AddActivity:(id)sender {
    AddActivityViewController *addActivityVC = (AddActivityViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddActivityViewController"];
    [self.navigationController pushViewController:addActivityVC animated:YES];
}
@end
