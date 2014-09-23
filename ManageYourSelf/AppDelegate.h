//
//  AppDelegate.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) SplashScreenViewController *splashView;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBar;
@end
