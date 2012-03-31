//
//  AppDelegate.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#define kDbDateFormat @"MMddyyyy"
#define kStringDateFormat @"MMM dd yyyy"

@class Trait;
@class Entry;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *traitsOrderPath, *entriesPath, *dateKey;
@property (nonatomic, retain) NSMutableDictionary *traits, *traitsOrder;
@property (nonatomic, retain) Trait *currentTrait;
// switch notes tracking into current entry
@property (nonatomic, retain) Entry *currentEntry;
@property (nonatomic, retain) NSMutableDictionary *allEntries, *todaysEntries;
@property (nonatomic, retain) NSDateFormatter *dbDateFormatter, *stringDateFormatter;

- (BOOL) saveCurrentEntry;
-(BOOL) writeEntriesFile;
-(BOOL) writeTraitsOrderFile;
@end
