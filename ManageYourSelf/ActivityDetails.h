//
//  ActivityDetails.h
//  ManageYourSelf
//
//  Created by Vandan on 5/1/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetails : NSObject
@property int activityId,userId;
@property (nonatomic, retain) NSString *activityTitle, *description;
@property (nonatomic, retain) NSDate *createdDate, *updatedDate,*startDate, *finishDate;
@property BOOL isDeleted,completionFlag;
@end
