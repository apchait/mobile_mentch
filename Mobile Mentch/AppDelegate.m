//
//  AppDelegate.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Trait.h"
#import "Entry.h"
@implementation AppDelegate

@synthesize window = _window, traits, traitsOrder, traitsOrderPath, allEntries, todaysEntries, entriesPath, currentTrait, currentEntry, dateKey, dbDateFormatter, stringDateFormatter, facebook, userDictionary;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Set up Facebook
   /* facebook = [[Facebook alloc] initWithAppId:@"126793304112432" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    [facebook authorize:permissions];
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
    }*/

    // Set the date
    self.stringDateFormatter = [[NSDateFormatter alloc] init];
    self.dbDateFormatter = [[NSDateFormatter alloc] init];
    [stringDateFormatter setDateFormat:kStringDateFormat];
    [dbDateFormatter setDateFormat:kDbDateFormat];
    dateKey = [dbDateFormatter stringFromDate:[NSDate date]];
    
    // Bring in all the traits
    self.traits = [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"traits" ofType:@"plist"]] objectForKey:@"traits"];
    
    
    // Bring in the trait order
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    self.traitsOrderPath = [documentsDir stringByAppendingPathComponent: @"traitsOrder.plist"];
    // Erase traits order
    //[[NSFileManager defaultManager] removeItemAtPath:traitsOrderPath error:nil];
    self.traitsOrder = [NSDictionary dictionaryWithContentsOfFile:traitsOrderPath];
    // If it is the first time, create an alphabetical order with all active
    if ([traitsOrder count] == 0) {
        self.traitsOrder = [[NSMutableDictionary alloc] init];
        for (NSString *trait in [traits allKeys]) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setValue:[[traits valueForKey:trait] valueForKey:@"keyIndex"] forKey:@"index"];
            [tempDict setValue:[NSNumber numberWithInt:1] forKey:@"active"];
            [traitsOrder setValue:tempDict forKey:trait];
        }
        [traitsOrder writeToFile:traitsOrderPath atomically:YES];
    }
    
    // Bring in all the entries
    self.entriesPath = [documentsDir stringByAppendingPathComponent: @"entries.plist"];
    // Erase all entries
    //[[NSFileManager defaultManager] removeItemAtPath:entriesPath error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:entriesPath]){
        NSDictionary *dic = [[NSDictionary alloc] init];
        [dic writeToFile:entriesPath atomically:YES];
    }
    self.allEntries = [[NSMutableDictionary alloc] initWithContentsOfFile:entriesPath];
    // Set up an empty dictionary if this is the first time the app is loaded
/*    if ([self.allEntries count] == 0) {
        self.allEntries = [[NSMutableDictionary alloc] init];
        for (id trait in self.traits){
            [self.allEntries setValue:[[NSMutableDictionary alloc]init] forKey:trait];
        }
        [self writeEntriesFile];
    } */
    
    if(![self.allEntries objectForKey:dateKey]){
        [self.allEntries setObject:[[NSMutableDictionary alloc] init] forKey:dateKey];
    }
    self.todaysEntries = [[NSMutableDictionary alloc] initWithDictionary:[self.allEntries objectForKey:dateKey]];
    
    
    // Print today's entries
  /*  for (id entry in allEntries){
        NSDictionary *e = [allEntries objectForKey:entry];
        if ([e objectForKey:dateKey]) {
            NSLog(@"%@ %@",entry,[[e objectForKey:dateKey] description]);            
        }
        
    }*/
    
    // Initialize variables
    self.currentTrait = [[Trait alloc] init];
    
    
    return YES;
}

#pragma mark Facebook Methods
// Facebook Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// Facebook For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

// Facebook
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self apiFQLIMe];
    
}

- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT email, uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
        self.userDictionary = result;
    }
}

#pragma mark Persistance Methods

-(BOOL) writeEntriesFile{
    // Add today's entries to all entries
    [self.allEntries setObject:todaysEntries forKey:dateKey];
    if ([self.allEntries writeToFile:entriesPath atomically:YES] == YES){
        NSLog(@"YES Written");
        return YES;
    }
    else {
        // raise alert
        NSLog(@"NOT Written");
        return NO;
    }
}

-(BOOL) writeTraitsOrderFile{
    if ([self.traitsOrder writeToFile:traitsOrderPath atomically:YES] == YES){
        NSLog(@"YES Written");
        return YES;
    }
    else {
        // raise alert
        NSLog(@"NOT Written");
        return NO;
    }
}


- (BOOL) saveCurrentEntry{
    // This method is called when done is clicked on RatingViewController, the trait being worked on at the time is saved into the database for the current date, overwriting existing entries if necessary
    
    // Check for empty notes or rating
    if(![currentEntry valueForKey:@"notes"]){
        [currentEntry setValue:@"" forKey:@"notes"];
    }
    if (![currentEntry valueForKey:@"rating"]) {
        [currentEntry setValue:[NSNumber numberWithInt:0] forKey:@"rating"];
    }
    
    // Set up a dictionary with data from the current entry
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[currentEntry valueForKey:@"rating"], [currentEntry valueForKey:@"notes"], nil] forKeys:[NSArray arrayWithObjects:@"rating",@"notes", nil]];
    
    // Add it to the dictionary at the name of the trait at todays date overwriting existing entries
    NSString *currentTraitName = [self.currentTrait valueForKey:@"name"];
    [self.todaysEntries setObject:data forKey:currentTraitName];
    [self.allEntries setObject:todaysEntries forKey:self.dateKey];
    
    return YES;
}



// ---------------- End of Added Code --------------- //



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self writeEntriesFile];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self writeEntriesFile];
}

@end
