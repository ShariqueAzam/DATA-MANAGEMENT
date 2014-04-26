//
//  ViewController.m
//  DATA MANAGEMENT
//
//  Created by student1 on 4/26/14.
//  Copyright (c) 2014 student1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize name,address,phone,status;

-(void) prepareStatement
{
    NSString *sqlString;
    const char *sql_stmt;
    
    //Prepare Insert SQL Statement
    
    sqlString = [NSString stringWithFormat:@"INSERT INTO CONTACTS (name, address,phone) VALUES (?,?,?)"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &insertStatement, NULL);
    
    //Prepare Update SQL Statement
    sqlString = [NSString stringWithFormat:@"UPDATE CONTACTS SET address =?, phone =? WHERE name =?"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &updateStatement, NULL);

    //Prepare Delete SQL Statement
    sqlString = [NSString stringWithFormat:@"DELETE FROM CONTACTS WHERE name=?"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &deleteStatement, NULL);
    
    
    //Prepare Select SQL Statement
    sqlString = [NSString stringWithFormat:@"SELECT address,phone FROM contacts WHERE name=?"];
    sql_stmt = [sqlString UTF8String];
    sqlite3_prepare_v2(contactDB, sql_stmt, -1, &selectStatement, NULL);

}

-(void) createContact
{
    sqlite3_bind_text(insertStatement, 1, [name.text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 2, [address.text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 3, [phone.text UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if (sqlite3_step(insertStatement)== SQLITE_DONE) {
        status.text =@"Contact Added";
        name.text =@" ";
        address.text =@" ";
        phone.text =@" ";
    }
    else{
        NSLog(@"%s",sqlite3_errmsg(contactDB));
        status.text =@"Failed to add Contact";
    }
    sqlite3_reset(insertStatement);
    sqlite3_clear_bindings(insertStatement);
}

-(void) updateContact
{
    sqlite3_bind_text(updateStatement, 1, [address.text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStatement, 2, [phone.text UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStatement, 3, [name.text UTF8String], -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(updateStatement)== SQLITE_DONE) {
        status.text =@"Contact updated";
        name.text =@" ";
        address.text =@" ";
        phone.text =@" ";
    }
    else{
        NSLog(@"%s",sqlite3_errmsg(contactDB));
        status.text =@"Failed to update Contact";
    }
    sqlite3_reset(updateStatement);
    sqlite3_clear_bindings(updateStatement);
}

-(void) deleteContact
{
    sqlite3_bind_text(deleteStatement, 1, [name.text UTF8String], -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(deleteStatement)== SQLITE_DONE) {
        status.text =@"Contact deleted";
        name.text =@" ";
        address.text =@" ";
        phone.text =@" ";
    }
    else{
        NSLog(@"%s",sqlite3_errmsg(contactDB));
        status.text =@"Failed to delete Contact";
    }
    sqlite3_reset(deleteStatement);
    sqlite3_clear_bindings(deleteStatement);

}

-(void) findContact
{
    sqlite3_bind_text(selectStatement, 1, [name.text UTF8String], -1, SQLITE_TRANSIENT);
    
    if (sqlite3_step(selectStatement)== SQLITE_ROW) {
        NSString *addressField = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(selectStatement, 0)];
        address.text =addressField;
                                  
        NSString *phoneField = [[NSString alloc]initWithUTF8String:(const char*)sqlite3_column_text(selectStatement, 1)];
        phone.text = phoneField;
        status.text =@"Match Found";
                                
    }
    else{
        NSLog(@"%s",sqlite3_errmsg(contactDB));
        status.text =@"Match not found";
        address.text=@" ";
        phone.text=@" ";
    }
    sqlite3_reset(selectStatement);
    sqlite3_clear_bindings(selectStatement);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *docsDir;
    docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    databasePath =[[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"contacts.sqlite"]];
    
    const char *dbpath =[databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB)== SQLITE_OK) {
        char *errMsg;
        const char *sql_stmt ="CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT,PHONE TEXT)";
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) !=SQLITE_OK) {
            status.text=@"Failed to create Table";
        }
        else{
            NSLog(@"Succes");
        }
    }else{
        status.text=@"Failed to open/create database";
    }
    
    [self prepareStatement];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
