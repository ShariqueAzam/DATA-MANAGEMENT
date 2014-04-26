//
//  ViewController.h
//  DATA MANAGEMENT
//
//  Created by student1 on 4/26/14.
//  Copyright (c) 2014 student1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController
{
    UITextField *name;
    UITextField *address;
    UITextField *phone;
    UILabel *status;
    
    NSString *databasePath;
    
    sqlite3 *contactDB;
    sqlite3_stmt *insertStatement;
    sqlite3_stmt *updateStatement;
    sqlite3_stmt *deleteStatement;
    sqlite3_stmt *selectStatement;

}
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *address;
@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (retain, nonatomic) IBOutlet UILabel *status;
-(IBAction) createContact;
-(IBAction) findContact;
-(IBAction) updateContact;
-(IBAction) deleteContact;


@end
