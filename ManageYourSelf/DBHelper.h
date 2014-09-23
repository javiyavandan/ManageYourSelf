//
//  DBHelper.h
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBHelper : NSObject
+(void)InitializeSQliteConfigurations;
+(BOOL)OpenDatabaseInReadOnlyMode;
+(BOOL)OpenDatabaseInReadWriteMode;
+(sqlite3_stmt*)PrepareSQLiteStatementFromQuery:(NSString*)sqlQuery;
+(void)BeginTransaction;
+(void)ExecuteSQLQuery:(NSString*)sqlQuery;
+(BOOL)ExecuteSQLiteStatement:(sqlite3_stmt*)sqliteStatement;
+(int)SelectLastInsertedRowId;
+(void)CommitTransaction;
+(void)CloseDatabaseConnection;
@end
