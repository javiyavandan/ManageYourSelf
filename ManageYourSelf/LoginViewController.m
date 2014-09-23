//
//  LoginViewController.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "LoginViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    //Set Background Image
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    //Tapgeature to hide Keyboard and revert scrollview position in tap of any view
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(revertBackToOriginalView)];
    [self.view addGestureRecognizer:tapGeature];
    
    //To customize Login button
    [btnLogin.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:154.0/255.0 blue:153.0/255.0 alpha:1].CGColor];
    [btnLogin.layer setCornerRadius:5.0];
    [btnLogin.layer setBorderWidth:1.0];
    btnLogin.layer.masksToBounds = YES;
    txtEmail.text = @"vd@test.com";
    txtPassword.text = @"123456";
    
    NSString *string = [self getIPAddress:NO];
    NSLog(@"%@",string);
    [self fetchSSIDInfo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//To revert scrollview view position as before
-(void)revertBackToOriginalView {
    [self.view endEditing:YES];
}

- (IBAction)Login_Click:(id)sender {
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        NSLog(@"Available");
        [self printdoc];
    } else {
         NSLog(@"Not Available");
    }
    
//    NSString *validation = [self validationCheck];
//    if([validation length] == 0)
//    {
//        NSString *email = txtEmail.text;
//        NSString *password = txtPassword.text;
//        UserDetails *userInfo = [UserRepository GetUserDetailsbyemailandpassword:email Password:password];
//        if(userInfo.userId > 0)
//        {
//            [GeneralDeclaration generalDeclaration].currentUser = userInfo;
//            TabViewController *tabViewVC = (TabViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
//            [self.navigationController pushViewController:tabViewVC animated:YES];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:@"You have entered incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//    else
//    {
//        validation = [@"Following fields are required:\n" stringByAppendingString:validation];
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[HelperMethods GetBundleName] message:validation delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }
}

-(void)printdoc
{
    NSMutableString *printBody = [NSMutableString stringWithFormat:@"%@, %@",@"Vandan", @"Javiya"];
    [printBody appendFormat:@"\n\n\n\nPrinted From *myapp*"];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Print";
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printBody];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentFromRect:btnLogin.frame inView:self.view animated:YES completionHandler:completionHandler];
    //[pic presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionHandler];
    
}

- (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }

    
    NSString *currentSSID = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
        } else {
            currentSSID=@"<<NONE>>";
        }
    } else {
        currentSSID=@"<<NONE>>"; 
    }
    
    
    return info ;
}

- (NSString *)getIPAddress:(BOOL)preferIPv4 {
    
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4,IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv4,IOS_WIFI @"/" , IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];

    Reachability *wifiReach = [Reachability reachabilityForLocalWiFi] ;
    [wifiReach startNotifier];
    
    NetworkStatus netStatus2 = [wifiReach currentReachabilityStatus];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        NSLog(@"No internet");
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"WiFi");
    }
    else if (status == ReachableViaWWAN)
    {
        NSLog(@"3G");
    }
    
    if(netStatus2 == NotReachable)
    {
        NSLog(@"No internet");
    }
    else if (netStatus2 == ReachableViaWiFi)
    {
        NSLog(@"WiFi");
    }
    else if (netStatus2 == ReachableViaWWAN)
    {
        NSLog(@"3G");
    }
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

//To check required field validations
-(NSString*)validationCheck {
    NSString *validationString = @"";
    if([txtEmail.text length] == 0)
        validationString = @"E-mail";
    if([txtPassword.text length] == 0)
    {
        if([validationString length] > 0)
            validationString = [validationString stringByAppendingString:@"\n"];
        validationString = [validationString stringByAppendingString:@"Password"];
    }
    return validationString;
}
@end
