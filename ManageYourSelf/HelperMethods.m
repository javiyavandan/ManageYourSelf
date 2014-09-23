//
//  HelperMethods.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+(NSString *)GetBundleName {
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+(NSString *)GetDataBasePath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"ManageYourSelf.sqlite"];

}

+(BOOL) CheckIfDatabaseExists:(NSString *) dbPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDBExists = [fileManager fileExistsAtPath:dbPath];
    return isDBExists;
}

+(NSString *)convertDateToString:(NSDate*)date {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:00"];
    return [dateFormat stringFromDate:date];
}

+(NSDate *)convertStringToDate:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm"];
    return [dateFormat dateFromString:dateString];
}

+(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter {
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}


+(UIToolbar *)GetToolbarWithDoneButton:(int)Tag ParentViewController:(UIViewController *)parentViewController {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:parentViewController action:@selector(doneButtonPressed:)];
    doneButton.tag = Tag;
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:parentViewController action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:parentViewController action:@selector(cancelButtonPressed:)];
    cancelButton.tag = Tag;
    [toolbar setItems:[NSArray arrayWithObjects:cancelButton,flexSpace, doneButton, Nil]];
    return toolbar;
}

+(CGFloat) GetDeviceWidth {
    return [GeneralDeclaration generalDeclaration].screenWidth;
}

+(CGFloat) GetDeviceHeight {
    return [GeneralDeclaration generalDeclaration].screenHeight;
}

+(BOOL) IsDeviceiPhone {
    UIDevice* thisDevice = [UIDevice currentDevice];
    return !(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}
@end
