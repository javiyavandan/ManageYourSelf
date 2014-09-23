//
//  LoginViewController.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabViewController.h"
#import "UserRepository.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/ioctl.h>
#include <net/if.h>
#define IFT_ETHER 0x6

#include <SystemConfiguration/SCDynamicStore.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en1"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIPrintInteractionControllerDelegate>
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton* btnLogin;
    IBOutlet UINavigationItem *navItem;
}

- (IBAction)Login_Click:(id)sender;
@end
