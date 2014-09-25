//
//  AppDelegate.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize tabBar,window,splashView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window.frame =  [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
    [self animateSplashScreen];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:229/255.f green:143/255.f blue:162/255.f alpha:1.0]];
    //[[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
    
    [DBHelper InitializeSQliteConfigurations];
    [self checkAndCreateDatabase:[HelperMethods GetDataBasePath]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    self.window.rootViewController = self.tabBar;
    

    return YES;
}


-(void) animateSplashScreen {
    CFTimeInterval animation_duration = 3;
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    splashView = (SplashScreenViewController *)[myStoryboard instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    [self.window addSubview:splashView.view];
    [self.window bringSubviewToFront:splashView.view];
    
    //Animation (fade away with zoom effect)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation_duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.window cache:YES];
    [splashView.lblLoadapp setFrame:CGRectMake(splashView.lblLoadapp.frame.origin.x,[HelperMethods GetDeviceHeight]/2 + [HelperMethods GetDeviceHeight]/4, splashView.lblLoadapp.frame.size.width,splashView.lblLoadapp.frame.size.height)];

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
}

-(void)removeFromSuperview {
    [splashView.view removeFromSuperview];

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
-(void) checkAndCreateDatabase:(NSString*)databasePath {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	if (success)
        return;
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ManageYourSelf.sqlite"];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

@end
