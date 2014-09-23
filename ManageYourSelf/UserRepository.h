//
//  UserRepository.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"

@interface UserRepository : NSObject


#pragma Select Methods for UserDetails
+(UserDetails *)GetUserInfoByUserId:(NSInteger)userId ;

+(int)CheckUserExists:(NSString*)email ;

+(UserDetails *)GetUserDetailsbyemailandpassword:(NSString*)email Password:(NSString*)password ;

#pragma Insert Methods for UserDetails
+(int) InsertUserInfo:(UserDetails *)userInfo ;

#pragma Update Methods for UserDetails
+(int) UpdateUserInfo:(UserDetails *)userData ;

#pragma Delete Methods for UserDetails
@end
