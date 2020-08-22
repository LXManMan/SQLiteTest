//
//  DBDatebase.m
//  SQLiteTest
//
//  Created by liuxx22666 on 2020/8/22.
//  Copyright © 2020 manman. All rights reserved.
//
#define column_type sqlite3_column_type(stmt, i)
#define column_value_text [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)]
#define column_value_int  [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, i)]
#define column_value_null  @""
#define column_name [NSString stringWithUTF8String:sqlite3_column_name(stmt,i)]
#import "DBDatebase.h"

@implementation DBDatebase
+(sqlite3 *)open{
    static sqlite3 *db =nil;
     NSString *dbName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lxx.db"];
    if (db) {
        int dbResult = sqlite3_open(dbName.UTF8String, &db);
        if(dbResult == SQLITE_OK){//打开成功
        } else {//打开失败
            NSLog(@"打开数据库失败");
            sqlite3_close(db);
        }
        return db;
    }
   
    //3.创建(打开)数据库，不存在时会自动创建数据库
    int dbResult = sqlite3_open(dbName.UTF8String, &db);
    if(dbResult == SQLITE_OK){//打开成功
        NSLog(@"打开数据库成功");
        //4.创建表
        //sql语句
        const char *sql = "create table if not exists user (id integer primary key autoincrement, name text)";
        //保存失败信息
        char * errMsg = NULL;
        //sqlite3_exec表示执行sql语句，创建表、增删改查都用这个方法
        int tableResult = sqlite3_exec(db, sql, NULL, NULL, &errMsg);
        if(tableResult == SQLITE_OK){//创建表成功
            NSLog(@"创建用户表成功");
        } else {//创建表失败
            NSLog(@"创建用户表失败");
            sqlite3_close(db);
        }
        
    } else {//打开失败
        NSLog(@"打开数据库失败");
        sqlite3_close(db);
    }
    return db;
}
///增
+(void)insertWithName:(NSString *)name{
    sqlite3 *db = [DBDatebase open];
    NSString *sql = [NSString stringWithFormat:@"insert into user(name) values('%@')",name];
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入失败--%s",errmsg);
    }else{
        NSLog(@"插入成功");
    }
    sqlite3_close(db);
}
///删
+(void)deleteWithName:(NSString *)name{
    sqlite3 *db = [DBDatebase open];
    NSString *sql = [NSString stringWithFormat:@"delete from user where name = '%@'",name];
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"删除失败--%s",errmsg);
    }else{
        NSLog(@"删除成功");
    }
    sqlite3_close(db);
}
///改
+(void)updateWithName:(NSString *)name{
    sqlite3 *db = [DBDatebase open];
    NSString *sql = [NSString stringWithFormat:@"update user set name = '%@' where id = 3",name];
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"更改失败--%s",errmsg);
    }else{
        NSLog(@"更改成功");
    }
    sqlite3_close(db);
}
///改
+(void)updateAllUserWithEnterPrisecode:(NSString *)enterPrisecode{
    sqlite3 *db = [DBDatebase open];
    NSString *sql = [NSString stringWithFormat:@"update user set enterPrisede = '%@'",enterPrisecode];
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"更改失败--%s",errmsg);
    }else{
        NSLog(@"更改成功");
    }
    sqlite3_close(db);
}
///查
+(NSArray *)queryAllUsers{
    sqlite3 *db = [DBDatebase open];
    NSString * sql = @"select * from user";
    //查询的句柄,游标
    sqlite3_stmt * stmt;
    NSMutableArray *mArray = [NSMutableArray array];
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        //查询数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取查询了多少列
            int count = sqlite3_column_count(stmt);
            //创建字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (int i = 0; i<count; i++) {
                
                //如果是text类型
                if (column_type == SQLITE_TEXT) {
                    [dic setValue:column_value_text forKeyPath:column_name];
                }
                if (column_type == SQLITE_INTEGER) {
                    [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, i)];
                    [dic setValue:column_value_int forKeyPath:column_name];
                }
                if (column_type == SQLITE_NULL) {
                    [dic setValue:column_value_null forKeyPath:column_name];
                }
            }
            [mArray addObject:dic];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return mArray;
}

///检查是表中是否有某个字段
+(BOOL)checkHaveColumn:(NSString *)column{
    sqlite3 *db = [DBDatebase open];
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where name='user' and sql like '%%%@%%'",column];
//           NSString * sql = @"select * from sqlite_master where name='user' and sql like '%enterPrisede%'";
    //查询的句柄,游标
    sqlite3_stmt * stmt;
    NSMutableArray *mArray = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        //查询数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取查询了多少列
            int count = sqlite3_column_count(stmt);
            //创建字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (int i = 0; i<count; i++) {
                //如果是text类型
                if (column_type == SQLITE_TEXT) {
                    [dic setValue:column_value_text forKeyPath:column_name];
                }
                if (column_type == SQLITE_INTEGER) {
                    [NSString stringWithFormat:@"%d",sqlite3_column_int(stmt, i)];
                    [dic setValue:column_value_int forKeyPath:column_name];
                }
                if (column_type == SQLITE_NULL) {
                    [dic setValue:column_value_null forKeyPath:column_name];
                }
            }
            [mArray addObject:dic];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    if (mArray.count ) {
        NSLog(@"存在这个字段");
        return YES;
    }else{
        return NO;
    }
}
///表中添加字段
+(void)addCloumnWith:(NSString *)column{
    BOOL have =  [self checkHaveColumn:column];
    if (!have) {
        sqlite3 *db = [DBDatebase open];
        NSString * sql = [NSString stringWithFormat:@"ALTER TABLE user ADD COLUMN '%@' text",column];
        //执行创建表的sql语句
        char *error = nil;
        int db_exec = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) ;
        if (db_exec == SQLITE_OK) {
            NSLog(@"插入字段成功");
        }else{
            NSLog(@"插入字段失败");
        }
        sqlite3_close(db);
    }
    
}
@end
