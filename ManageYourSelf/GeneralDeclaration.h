//
//  GeneralDeclaration.h
//  ManageYourSelf
//
//  Created by Vandan on 5/1/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"

@interface GeneralDeclaration : NSObject
@property (nonatomic,retain) UserDetails *currentUser;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) BOOL isiPhone;
+(GeneralDeclaration *)generalDeclaration;

@end
