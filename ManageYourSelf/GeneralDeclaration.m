//
//  GeneralDeclaration.m
//  ManageYourSelf
//
//  Created by Vandan on 5/1/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "GeneralDeclaration.h"

@implementation GeneralDeclaration

@synthesize currentUser = _currentUser;
@synthesize screenHeight = _screenHeight;
@synthesize screenWidth = _screenWidth;
@synthesize isiPhone = _isiPhone;;

static dispatch_once_t pred;
static GeneralDeclaration *shared = nil;
+(GeneralDeclaration *)generalDeclaration {
dispatch_once(&pred, ^{
    shared = [[GeneralDeclaration alloc] init];
    shared.currentUser = [[UserDetails alloc]init];
    shared.isiPhone = [HelperMethods IsDeviceiPhone];
    shared.screenWidth = shared.isiPhone == YES ? 320.0 : 768.0;
    shared.screenHeight = [[UIScreen mainScreen] bounds].size.height;
});
    return shared;
}
@end
