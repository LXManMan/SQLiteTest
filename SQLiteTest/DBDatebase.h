//
//  DBDatebase.h
//  SQLiteTest
//
//  Created by liuxx22666 on 2020/8/22.
//  Copyright © 2020 manman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
@interface DBDatebase : NSObject

+(sqlite3 *)open;
///增
+(void)insertWithName:(NSString *)name;
///删
+(void)deleteWithName:(NSString *)name;
///改
+(void)updateWithName:(NSString *)name;
///改
+(void)updateAllUserWithEnterPrisecode:(NSString *)enterPrisecode;
///查
+(NSArray *)queryAllUsers;

///检查是表中是否有某个字段
+(BOOL)checkHaveColumn:(NSString *)column;

///表中添加字段
+(void)addCloumnWith:(NSString *)column;


@end

