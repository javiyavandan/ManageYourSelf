//
//  UserDetails.h
//  ManageYourSelf
//
//  Created by Vandan on 5/1/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject

@property int userId,gender;
@property (nonatomic, retain) NSString *firstName, *lastName, *email, *password;
@property (nonatomic, retain) NSDate *createdDate, *updatedDate;
@property BOOL isDeleted;
@end
