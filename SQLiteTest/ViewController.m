//
//  ViewController.m
//  SQLiteTest
//
//  Created by liuxx22666 on 2020/8/21.
//  Copyright © 2020 manman. All rights reserved.
//
#import <sqlite3.h>
#import "ViewController.h"
#import "DBDatebase.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)add:(id)sender {
    
    [DBDatebase insertWithName:@"新新"];
    [DBDatebase insertWithName:@"漫漫"];
    [DBDatebase insertWithName:@"梅梅"];
    [DBDatebase insertWithName:@"沙沙"];
    [DBDatebase insertWithName:@"小明"];
    [DBDatebase insertWithName:@"小丽"];
}
- (IBAction)delete:(id)sender {
    [DBDatebase deleteWithName:@"梅梅"];
}
- (IBAction)change:(id)sender {
    [DBDatebase updateWithName:@"大魔王"];

}
- (IBAction)query:(id)sender {
    NSArray *array =[DBDatebase queryAllUsers];
    NSLog(@"%@",array);

}
- (IBAction)addCloumn:(id)sender {

}
- (IBAction)addEnterpriseForALL:(id)sender {
    
    [DBDatebase addCloumnWith:@"modelNumber"];

    
}
- (IBAction)addEnterprisedeForUser:(id)sender {
    [DBDatebase updateAllUserWithEnterPrisecode:@"0000"];
}

@end
