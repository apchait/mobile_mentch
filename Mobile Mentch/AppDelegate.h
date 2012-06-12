//
//  AppDelegate.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import <sqlite3.h>
#define kDbDateFormat @"MMddyyyy"
#define kStringDateFormat @"MMM dd yyyy"

@class Trait;
@class Entry;
@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate, FBRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *traitsPath, *entriesPath, *dateKey;
@property (nonatomic, retain) NSMutableDictionary *traits;
@property (nonatomic, retain) Trait *currentTrait;
// switch notes tracking into current entry
@property (nonatomic, retain) Entry *currentEntry;
@property (nonatomic, retain) NSMutableDictionary *allEntries, *todaysEntries;
@property (nonatomic, retain) NSDateFormatter *dbDateFormatter, *stringDateFormatter;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSDictionary *userDictionary;

-(BOOL) saveCurrentEntry;
-(BOOL) writeEntriesFile;
-(BOOL) writeTraitsFile;
@end
