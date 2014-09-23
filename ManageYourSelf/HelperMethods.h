//
//  HelperMethods.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperMethods : NSObject

+(NSString *)GetBundleName ;

+(NSString *)GetDataBasePath;

+(BOOL) CheckIfDatabaseExists:(NSString *) dbPath;

+(NSString *)convertDateToString:(NSDate*)date;

+(NSDate *)convertStringToDate:(NSString *)dateString;

+(UIToolbar *)GetToolbarWithDoneButton:(int)Tag ParentViewController:(UIViewController *)parentViewController ;

+(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter;

+(CGFloat) GetDeviceWidth;
+(CGFloat) GetDeviceHeight;
+(BOOL) IsDeviceiPhone ;
@end
