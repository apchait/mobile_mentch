//
//  AppDelegate.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Trait.h"

@implementation AppDelegate

@synthesize window = _window, databaseName, databasePath, traits, currentTrait;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialize variables
    self.currentTrait = [[Trait alloc] init];
    
    // Initialize sqlite
    databaseName = @"traits.sqlite";
    
    // Get the path to the documents directory and append the databaseName
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    
    
    // Execute the "checkAndCreateDatabase" function
    [self checkAndCreateDatabase];
    
    // Query the database for all animal records and construct the "animals" array
    [self readTraitsFromDatabase];
    
    
    //NSString *plistPath = [[NSString alloc] initWithString:[documentsDir stringByAppendingPathComponent: @"traits.plist"]];
    
    //self.traits = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] objectForKey:@"traits"];
    
    // Open the traits plist from the Supporting Files folder to load traits and their descriptions
    self.traits = [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"traits" ofType:@"plist"]] objectForKey:@"traits"];
    
    return YES;
}
		
- (void) checkAndCreateDatabase {
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];

}

- (void) readTraitsFromDatabase{
    
    
    // Setup the database object
    sqlite3 *database;
    
    // Init the BuildingsArray
    //traits = [[NSMutableArray alloc] init];
    
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = "select * from traits";
        
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                // Read the data from the result row
                
                //Unique ID Field 
                NSMutableString *tUniqueID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                // Name Field
                NSMutableString *tName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                // Description Field
                NSMutableString *tDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                // Custon Description Field
                NSMutableString *tCustomDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                
                
                
                // This is to remove the double quotes at the beginning and end of line
                NSString *UniqueID = [tUniqueID substringWithRange:NSMakeRange(1, tUniqueID.length -2)];
                NSString *name =  [tName substringWithRange:NSMakeRange(1, tName.length -2)];
                NSString *description = [tDescription substringWithRange:NSMakeRange(1, tDescription.length -2)];
                NSString *customDescription =  [tCustomDescription substringWithRange:NSMakeRange(1, tCustomDescription.length -2)];
                
                
                
                // Important To Print Out Values To Ensure Correctness
                // Debugging Step 1 
                
                // My Error 1
                // %g is for type double
                NSLog(@"Name: %@ Description: %@ Custom Description: %@", name, description, customDescription);
                
                // Corect Output
                // I converted to double since CLLocationCoordinates2D are of type double
                //  NSLog(@"Name: %@ Latitude: %g Longitude: %g", name, [latitude doubleValue], [longitude doubleValue]);
                
                
                
                // Create new building object and then add it to the items array. 
                
                
                
            }
        }
        
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
        
    }
    // Nifty Sorting Tricks in Objective-C
    
    
    
    // Important To Print Out Values for Objects 
    // Debug Step 2
    /*
     for (Building *theBuilding in items) {
     
     NSLog(@"Name: %@ Latitude: %g Longitude: %g", theBuilding.name, [theBuilding.latitude doubleValue], [theBuilding.longitude doubleValue]);
     
     }
     */
    
    
    // Nifty Objective-C Method to Print Out Values using For Loops
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray = [traits sortedArrayUsingDescriptors:sortDescriptors];
    
  //  self.traits = [sortedArray mutableCopy];
    
    sqlite3_close(database);
    
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
}

@end
