//
//  ActivityRepository.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityDetails.h"

@interface ActivityRepository : NSObject



#pragma Select Methods for ActivityDetails
+(NSMutableArray *)GetallactivitiesbyuserId:(NSInteger)userId ;

+(NSMutableArray *)GetallIncompleteActivityDetails:(NSInteger)userId;

+(ActivityDetails *)GetactivitydetailsbyactivityId:(NSInteger)activityId;

+(NSMutableArray *)GetallfutureactivitiesbyuserId:(NSInteger)userId;

+(NSMutableArray *)Selectcompletedactivitylist:(NSInteger)userId;
#pragma Insert Methods for ActivityDetails
+(int) Insertnewactivity:(ActivityDetails *)activityDetails ;

#pragma Update Methods for ActivityDetails
+(int) Updatenewactivity:(ActivityDetails *)activityDetails ;

@end
