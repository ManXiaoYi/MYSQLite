//
//  ViewController.m
//  MYSQLite
//
//  Created by 满孝意 on 2016/12/1.
//  Copyright © 2016年 满孝意. All rights reserved.
//

#import "ViewController.h"
#import "MYSQLiteTool.h"

#define TABLE @"TESTTABLE"

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 初始化
    NSDictionary *dict = @{
                           @"id": @"integer primary key autoincrement",
                           @"name": @"text not null",
                           @"age": @"integer"
                           };
    
    self.db = [[MYSQLiteTool sharedInstance] createDataBaseWithDBName:@"MYCESHI.sqlite"];
    [[MYSQLiteTool sharedInstance] DataBase:self.db createTable:TABLE keyTypes:dict];
}

- (IBAction)insert:(id)sender {
    NSDictionary *dict = @{
                           @"name": @"my",
                           @"age": @"1241",
                           };
    
    [[MYSQLiteTool sharedInstance] DataBase:self.db table:TABLE insertKeyValues:dict];
}

- (IBAction)delete:(id)sender {
    [[MYSQLiteTool sharedInstance] DataBase:self.db clearDataForTable:TABLE];
}

- (IBAction)update:(id)sender {
    NSDictionary *dict = @{
                           @"name": @"HXXX",
                           @"age": @"1241"
                           };
    
    [[MYSQLiteTool sharedInstance] DataBase:self.db table:TABLE updateKeyValues:dict];
}

- (IBAction)select:(id)sender {
    NSDictionary *dict = @{
                           @"name": @"text"
                           };
    NSDictionary *conditionDict = @{
                                    @"name": @"my"
                                    };
    
    // 查询
    NSArray *resultArray = [[MYSQLiteTool sharedInstance] DataBase:self.db table:TABLE selectKeyTypes:dict];
    NSLog(@"resultArray - %@", resultArray);
    
    // 条件查询
    NSArray *conditionArray = [[MYSQLiteTool sharedInstance] DataBase:self.db table:TABLE selectKeyTypes:dict whereCondition:conditionDict];
    NSLog(@"conditionArray - %@", conditionArray);
    
    // 条件查询
    NSArray *vagueArray = [[MYSQLiteTool sharedInstance] DataBase:self.db table:TABLE selectKeyTypes:dict whereKey:@"age" beginStr:@"12"];
    NSLog(@"vagueArray - %@", vagueArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
