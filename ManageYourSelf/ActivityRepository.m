//
//  ActivityRepository.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "ActivityRepository.h"

@implementation ActivityRepository

#pragma Select Methods for ActivityDetails
+(NSMutableArray *)GetallactivitiesbyuserId:(NSInteger)userId {
    NSMutableArray *activityData = [[NSMutableArray alloc]init];
    @try {
        if([DBHelper OpenDatabaseInReadOnlyMode])
        {
            NSString *query1 = [NSString stringWithFormat:@"SELECT ActivityId, UserId, ifNULL(ActivityTitle,''), ifNULL(Description,''), CompletionFlag, StartDate,FinishDate, CreatedDate, UpdatedDate FROM ActivityDetails where UserId = %d and ifnull(IsDeleted,0) = 0 and CompletionFlag = 0 and '%@' between StartDate and FinishDate",userId ,[HelperMethods convertDateToString:[NSDate date]]];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            if(sqlStatement !=nil)
            {
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
                    activityInfo.activityId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.ActivityTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.completionFlag = sqlite3_column_int(sqlStatement, columnNo++);
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.startDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.finishDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    [activityData addObject:activityInfo];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        [DBHelper CloseDatabaseConnection];
        return activityData;
    }
}

+(NSMutableArray *)GetallIncompleteActivityDetails:(NSInteger)userId {
    NSMutableArray *activityData = [[NSMutableArray alloc]init];
    @try {
        if([DBHelper OpenDatabaseInReadOnlyMode])
        {
            NSString *query1 = [NSString stringWithFormat:@"SELECT ActivityId, UserId, ifNULL(ActivityTitle,''), ifNULL(Description,''), CompletionFlag, StartDate,FinishDate, CreatedDate, UpdatedDate FROM ActivityDetails where UserId = %d and ifnull(IsDeleted,0) = 0 and CompletionFlag = 0 and FinishDate < '%@'",userId ,[HelperMethods convertDateToString:[NSDate date]]];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            if(sqlStatement !=nil)
            {
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
                    activityInfo.activityId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.ActivityTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.completionFlag = sqlite3_column_int(sqlStatement, columnNo++);
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.startDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.finishDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    [activityData addObject:activityInfo];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        [DBHelper CloseDatabaseConnection];
        return activityData;
    }
}


+(NSMutableArray *)GetallfutureactivitiesbyuserId:(NSInteger)userId {
    NSMutableArray *activityData = [[NSMutableArray alloc]init];
    @try {
        if([DBHelper OpenDatabaseInReadOnlyMode])
        {
            NSString *query1 = [NSString stringWithFormat:@"SELECT ActivityId, UserId, ifNULL(ActivityTitle,''), ifNULL(Description,''), CompletionFlag, StartDate,FinishDate, CreatedDate, UpdatedDate FROM ActivityDetails where UserId = %d and ifnull(IsDeleted,0) = 0 and StartDate > '%@' and CompletionFlag = 0",userId,[HelperMethods convertDateToString:[NSDate date]] ];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            if(sqlStatement !=nil)
            {
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
                    activityInfo.activityId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.ActivityTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.completionFlag = sqlite3_column_int(sqlStatement, columnNo++);
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.startDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.finishDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    [activityData addObject:activityInfo];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        [DBHelper CloseDatabaseConnection];
        return activityData;
    }
}


+(NSMutableArray *)Selectcompletedactivitylist:(NSInteger)userId {
    NSMutableArray *activityData = [[NSMutableArray alloc]init];
    @try {
        if([DBHelper OpenDatabaseInReadOnlyMode])
        {
            NSString *query1 = [NSString stringWithFormat:@"SELECT ActivityId, UserId, ifNULL(ActivityTitle,''), ifNULL(Description,''), CompletionFlag, StartDate,FinishDate, CreatedDate, UpdatedDate FROM ActivityDetails where UserId = %d and ifnull(IsDeleted,0) = 0 and  CompletionFlag = 1  Order By StartDate ",userId ];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            if(sqlStatement !=nil)
            {
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    ActivityDetails *activityInfo = [[ActivityDetails alloc]init];
                    activityInfo.activityId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.ActivityTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.completionFlag = sqlite3_column_int(sqlStatement, columnNo++);
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.startDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.finishDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    [activityData addObject:activityInfo];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        [DBHelper CloseDatabaseConnection];
        return activityData;
    }
}

+(ActivityDetails *)GetactivitydetailsbyactivityId:(NSInteger)activityId {
    ActivityDetails *activityInfo = [[ActivityDetails alloc] init];
    @try
    {
        if([DBHelper OpenDatabaseInReadOnlyMode]) {
            NSString *query1 = [NSString stringWithFormat:@"SELECT ActivityId, UserId, ifNULL(ActivityTitle,''), ifNULL(Description,''), CompletionFlag, StartDate,FinishDate, CreatedDate, UpdatedDate FROM ActivityDetails where ActivityId = %d and ifnull(IsDeleted,0) = 0",activityId ];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            
            if(sqlStatement != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    activityInfo.activityId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    activityInfo.ActivityTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    activityInfo.completionFlag = sqlite3_column_int(sqlStatement, columnNo++);
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.startDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.finishDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        activityInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [DBHelper CloseDatabaseConnection];
        return activityInfo;
    }
    
    
}

#pragma Insert Methods For ActivityDetails
+(int) Insertnewactivity:(ActivityDetails *)activityDetails {
    int activityId = 0;
    @try
    {
        if([DBHelper OpenDatabaseInReadWriteMode])
        {
            NSString *sqlQuery = @"insert into ActivityDetails (UserId, ActivityTitle, Description, CompletionFlag, StartDate, FinishDate, CreatedDate) Values(?, ?, ?, ?, ?, ?, ?)";
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:sqlQuery];
            if(sqlStatement != nil)
            {
                int colNo = 1;
                
                sqlite3_bind_int(sqlStatement, colNo++, activityDetails.userId);
                sqlite3_bind_text(sqlStatement, colNo++, [activityDetails.activityTitle UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [activityDetails.description UTF8String] , -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(sqlStatement, colNo++, activityDetails.completionFlag);
                sqlite3_bind_text(sqlStatement, colNo++, [[HelperMethods convertDateToString:activityDetails.startDate] UTF8String] , -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [[HelperMethods convertDateToString:activityDetails.finishDate] UTF8String] , -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [[HelperMethods convertDateToString:[NSDate date]] UTF8String] , -1, SQLITE_TRANSIENT);
                
                if([DBHelper ExecuteSQLiteStatement:sqlStatement])
                {
                    
                    activityId = [DBHelper SelectLastInsertedRowId];
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [DBHelper CloseDatabaseConnection];
        return activityId;
    }
}

#pragma Update Methods For ActivityDetails
+(int) Updatenewactivity:(ActivityDetails *)activityDetails {
int activityId = 0;
@try
{
    if([DBHelper OpenDatabaseInReadWriteMode])
    {
        NSString *query = @"update ActivityDetails Set ActivityTitle = ?, Description = ?, CompletionFlag = ?, StartDate = ?, FinishDate = ? ,Isdeleted = ?, UpdatedDate = ? where UserId = ? and ActivityId = ?";
        
        sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query];
        if(sqlStatement != nil)
        {
            int columnNo = 1;
            sqlite3_bind_text(sqlStatement, columnNo++, [activityDetails.activityTitle UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlStatement, columnNo++, [activityDetails.description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(sqlStatement, columnNo++, activityDetails.completionFlag);
            sqlite3_bind_text(sqlStatement, columnNo++, [[HelperMethods convertDateToString:activityDetails.startDate] UTF8String] , -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlStatement, columnNo++, [[HelperMethods convertDateToString:activityDetails.finishDate] UTF8String] , -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(sqlStatement, columnNo++, activityDetails.isDeleted);
            sqlite3_bind_text(sqlStatement, columnNo++, [[HelperMethods convertDateToString:[NSDate date]] UTF8String] , -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_int(sqlStatement, columnNo++, activityDetails.userId);
            
            sqlite3_bind_int(sqlStatement, columnNo++, activityDetails.activityId);
            
            if([DBHelper ExecuteSQLiteStatement:sqlStatement])
            {
                activityId = activityDetails.activityId;
            }
            [DBHelper CloseDatabaseConnection];
            
            
        }
    }
}
@catch(NSException *exception)
{
    NSLog(@"%@",exception);
}
@finally {
    [DBHelper CloseDatabaseConnection];
    return activityId;
}
}
@end
