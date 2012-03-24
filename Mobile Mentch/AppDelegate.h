//
//  AppDelegate.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kSQLFile   @"data.sqlite3"
@class Trait;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *databaseName;
    NSString *databasePath;
    Trait *currentTrait;
    NSMutableDictionary *traits;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *databaseName, *databasePath;
@property (nonatomic, retain) NSMutableDictionary *traits;
@property (nonatomic, retain) Trait *currentTrait;
@property (nonatomic, retain) NSString *notes;

-(void) checkAndCreateDatabase;
-(void) readTraitsFromDatabase;

@end
