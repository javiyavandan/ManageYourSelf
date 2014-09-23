//
//  UserRepository.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "UserRepository.h"

@implementation UserRepository
#pragma Select Methods For User Details
+(UserDetails *)GetUserInfoByUserId:(NSInteger)userId {
    UserDetails *userInfo = [[UserDetails alloc] init];
    @try
    {
        if([DBHelper OpenDatabaseInReadOnlyMode]) {
            NSString *query1 = [NSString stringWithFormat:@"SELECT UserId, ifNULL(FirstName,''), ifNULL(LastName,''), Gender,ifNULL(Email, ''), ifNULL(Password, ''), CreatedDate, UpdatedDate FROM UserDetails where UserId = %d and ifnull(IsDeleted,0) = 0", userId];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            
            if(sqlStatement != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    userInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    userInfo.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    userInfo.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    userInfo.gender = sqlite3_column_int(sqlStatement, columnNo++);
                    userInfo.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    
                    userInfo.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        userInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        userInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
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
        return userInfo;
    }
}

+(int)CheckUserExists:(NSString*)email {
    int userId = 0;
    @try
    {
        if([DBHelper OpenDatabaseInReadOnlyMode]) {
            NSString *query1 = [NSString stringWithFormat:@"SELECT UserId FROM UserDetails where email = '%@' and ifnull(IsDeleted,0) = 0", email];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            
            if(sqlStatement != nil) {
                
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    userId = sqlite3_column_int(sqlStatement, columnNo++);

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
        return userId;
    }
    
}


+(UserDetails *)GetUserDetailsbyemailandpassword:(NSString*)email Password:(NSString*)password {
    UserDetails *userInfo = [[UserDetails alloc] init];
    @try
    {
        if([DBHelper OpenDatabaseInReadOnlyMode]) {
            NSString *query1 = [NSString stringWithFormat:@"SELECT UserId, ifNULL(FirstName,''), ifNULL(LastName,''), Gender,ifNULL(Email, ''), ifNULL(Password, ''), CreatedDate, UpdatedDate FROM UserDetails where email = '%@' and password = '%@' and ifnull(IsDeleted,0) = 0", email,password];
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query1];
            
            if(sqlStatement != nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                    int columnNo = 0;
                    userInfo.userId = sqlite3_column_int(sqlStatement, columnNo++);
                    userInfo.firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    userInfo.lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    userInfo.gender = sqlite3_column_int(sqlStatement, columnNo++);
                    userInfo.email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    
                    userInfo.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)];
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        userInfo.createdDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
                    else
                        columnNo ++;
                    
                    if(sqlite3_column_text(sqlStatement, columnNo) != nil)
                        userInfo.updatedDate = [HelperMethods convertStringToDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, columnNo++)] ];
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
        return userInfo;
    }

}

#pragma Insert Methods For User Details
+(int) InsertUserInfo:(UserDetails *)userInfo {
    int userId = 0;
    @try
    {
        if([DBHelper OpenDatabaseInReadWriteMode])
        {
            NSString *sqlQuery = @"insert into UserDetails (FirstName, LastName, Gender, Email, Password, CreatedDate, UpdatedDate) Values(?, ?, ?, ?, ?, ?, ?)";
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:sqlQuery];
            if(sqlStatement != nil)
            {
                int colNo = 1;
                
                sqlite3_bind_text(sqlStatement, colNo++, [userInfo.firstName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [userInfo.lastName UTF8String] , -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(sqlStatement, colNo++, userInfo.gender);
                sqlite3_bind_text(sqlStatement, colNo++, [userInfo.email UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [userInfo.password UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [[HelperMethods convertDateToString:userInfo.createdDate] UTF8String] , -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, colNo++, [[HelperMethods convertDateToString:userInfo.createdDate] UTF8String] , -1, SQLITE_TRANSIENT);
              
                if([DBHelper ExecuteSQLiteStatement:sqlStatement])
                {
                    
                    userId = [DBHelper SelectLastInsertedRowId];
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
        return userId;
    }
}

#pragma Update Methods For User Details
+(int) UpdateUserInfo:(UserDetails *)userData {
    int userId = 0;
    @try
    {
        if([DBHelper OpenDatabaseInReadWriteMode])
        {
            
            NSString *query = @"update UserDetails Set FirstName = ?, LastName = ?, Gender = ?, Password = ?, UpdatedDate = ? where UserId = ?";
            
            sqlite3_stmt *sqlStatement = [DBHelper PrepareSQLiteStatementFromQuery:query];
            if(sqlStatement != nil)
            {
                int columnNo = 1;
                sqlite3_bind_text(sqlStatement, columnNo++, [userData.firstName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, columnNo++, [userData.lastName UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(sqlStatement, columnNo++, userData.gender);
                sqlite3_bind_text(sqlStatement, columnNo++, [userData.password UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlStatement, columnNo++, [[HelperMethods convertDateToString:[NSDate date]] UTF8String] , -1, SQLITE_TRANSIENT);

                sqlite3_bind_int(sqlStatement, columnNo++, userData.userId);
                
                if([DBHelper ExecuteSQLiteStatement:sqlStatement])
                {
                    userId = userData.userId;
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
        return userId;
    }
}

@end
