//
//  DBHelper.m
//  ManageYourSelf
//
//  Created by User on 4/30/14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "DBHelper.h"

@implementation DBHelper
static sqlite3 *mainThreadDB = nil;
static sqlite3 *backGroundThreadDB = nil;

+(void)InitializeSQliteConfigurations {
    if(sqlite3_config(SQLITE_CONFIG_MULTITHREAD) == SQLITE_OK)
        NSLog(@"%d", sqlite3_threadsafe());
}

+(BOOL)OpenDatabaseInReadOnlyMode {
    bool databaseOpenStatus = NO;
    if(![NSThread isMainThread])
    {
        if([HelperMethods CheckIfDatabaseExists:[HelperMethods GetDataBasePath]]) {
            if(sqlite3_open_v2([[HelperMethods GetDataBasePath] UTF8String], &backGroundThreadDB, SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX, NULL) == SQLITE_OK)
                databaseOpenStatus = YES;
            else
            {
                NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(backGroundThreadDB), sqlite3_errcode(backGroundThreadDB)];
                NSLog(@"%@", errorMessage);
                
            }
        }
        else
            NSLog(@"Database file does not exist.");
    }
    else
    {
        if([HelperMethods CheckIfDatabaseExists:[HelperMethods GetDataBasePath]]) {
            if(sqlite3_open_v2([[HelperMethods GetDataBasePath] UTF8String], &mainThreadDB, SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX, NULL) == SQLITE_OK)
                databaseOpenStatus = YES;
            else
            {
                NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(mainThreadDB), sqlite3_errcode(mainThreadDB)];
                NSLog(@"%@", errorMessage);
                
            }
        }
        else
            NSLog(@"Database file does not exist.");
    }
    return databaseOpenStatus;
}

+(BOOL)OpenDatabaseInReadWriteMode {
    bool databaseOpenStatus = NO;
    if(![NSThread isMainThread])
    {
        if([HelperMethods CheckIfDatabaseExists:[HelperMethods GetDataBasePath]]) {
            if(sqlite3_open_v2([[HelperMethods GetDataBasePath] UTF8String], &backGroundThreadDB, SQLITE_OPEN_READWRITE | SQLITE_OPEN_NOMUTEX, NULL) == SQLITE_OK)
                databaseOpenStatus = YES;
            else
            {
                NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(backGroundThreadDB), sqlite3_errcode(backGroundThreadDB)];
                NSLog(@"%@", errorMessage);
               
            }
        }
        else
        {}
    }
    else
    {
        if([HelperMethods CheckIfDatabaseExists:[HelperMethods GetDataBasePath]]) {
            if(sqlite3_open_v2([[HelperMethods GetDataBasePath] UTF8String], &mainThreadDB, SQLITE_OPEN_READWRITE | SQLITE_OPEN_NOMUTEX, NULL) == SQLITE_OK)
                databaseOpenStatus = YES;
            else
            {
                NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(mainThreadDB), sqlite3_errcode(mainThreadDB)];
                NSLog(@"%@", errorMessage);
                
            }
        }
        else
        {}
    }
    return databaseOpenStatus;
}

+(sqlite3_stmt*)PrepareSQLiteStatementFromQuery:(NSString*)sqlQuery {
    const char *utf8Query = [sqlQuery UTF8String];
    sqlite3_stmt *sqliteStatement;
    if(![NSThread isMainThread])
    {
        if(sqlite3_prepare_v2(backGroundThreadDB, utf8Query, -1, &sqliteStatement, NULL) == SQLITE_OK)
            return sqliteStatement;
        else
        {
            NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(backGroundThreadDB), sqlite3_errcode(backGroundThreadDB)];
            NSLog(@"%@", errorMessage);
            
            return nil;
        }
    }
    else
    {
        int statementPrepareStatus = sqlite3_prepare_v2(mainThreadDB, utf8Query, -1, &sqliteStatement, NULL);
        if(statementPrepareStatus == SQLITE_OK)
            return sqliteStatement;
        else
        {
            NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(mainThreadDB), sqlite3_errcode(mainThreadDB)];
            NSLog(@"%@", errorMessage);
            
            return nil;
        }
    }
}

+(void)ExecuteSQLQuery:(NSString*)sqlQuery {
    char* errorMessage;
    if(![NSThread isMainThread])
        sqlite3_exec(backGroundThreadDB, [sqlQuery UTF8String], NULL, NULL, &errorMessage);
    else
        sqlite3_exec(mainThreadDB, [sqlQuery UTF8String], NULL, NULL, &errorMessage);
}

+(BOOL)ExecuteSQLiteStatement:(sqlite3_stmt*)sqliteStatement {
    bool statementExecuted = NO;
    int statementExecutionStatus = sqlite3_step(sqliteStatement);
    if(SQLITE_DONE == statementExecutionStatus)
    {
        sqlite3_clear_bindings(sqliteStatement);
        sqlite3_reset(sqliteStatement);
        sqlite3_finalize(sqliteStatement);
        statementExecuted = YES;
    }
    else if(statementExecutionStatus == SQLITE_BUSY)
    {
        while (true) {
            NSLog(@"Database is busy. Executing statement in loop.");
            statementExecutionStatus = sqlite3_step(sqliteStatement);
            if(SQLITE_DONE == statementExecutionStatus)
            {
                NSLog(@"Statement Executed.");
                sqlite3_clear_bindings(sqliteStatement);
                sqlite3_reset(sqliteStatement);
                sqlite3_finalize(sqliteStatement);
                statementExecuted = YES;
                break;
            }
        }
    }
    else
    {
        statementExecuted = NO;
        NSString *errorMessage = @"";
        if(![NSThread isMainThread])
            errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(backGroundThreadDB), sqlite3_errcode(backGroundThreadDB)];
        else
            errorMessage = [[NSString alloc] initWithFormat:@"%s Error accured. '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(mainThreadDB), sqlite3_errcode(mainThreadDB)];
        NSLog(@"%@", errorMessage);
        
    }
    return statementExecuted;
}

+(int)SelectLastInsertedRowId {
    if(![NSThread isMainThread])
        return (int)sqlite3_last_insert_rowid(backGroundThreadDB);
    else
        return (int)sqlite3_last_insert_rowid(mainThreadDB);
}

+(void)CloseDatabaseConnection {
    @try {
        if(![NSThread isMainThread])
        {
            int rc = sqlite3_close(backGroundThreadDB);
            if (rc == SQLITE_BUSY)
            {
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(backGroundThreadDB, 0x00)) != 0)
                    sqlite3_finalize(stmt);
                rc = sqlite3_close(backGroundThreadDB);
                backGroundThreadDB = nil;
            }
        }
        else
        {
            int rc = sqlite3_close(mainThreadDB);
            if (rc == SQLITE_BUSY)
            {
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(mainThreadDB, 0x00)) != 0)
                    sqlite3_finalize(stmt);
                rc = sqlite3_close(mainThreadDB);
                mainThreadDB = nil;
            }
        }
    }
    @catch (NSException *exception) {
       
    }
    @finally {
    }
}

+(void)BeginTransaction {
    char* errorMessage;
    if(![NSThread isMainThread])
        sqlite3_exec(backGroundThreadDB, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
    else
        sqlite3_exec(mainThreadDB, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
}

+(void)CommitTransaction {
    char* errorMessage;
    if(![NSThread isMainThread])
        sqlite3_exec(backGroundThreadDB, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    else
        sqlite3_exec(mainThreadDB, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
}
@end
