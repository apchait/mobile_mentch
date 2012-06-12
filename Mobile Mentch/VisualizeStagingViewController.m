//
//  VisualizeStagingViewController.m
//  Mobile Mentch
//
//  Created by ARIEL CHAIT on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VisualizeStagingViewController.h"
#import "AppDelegate.h"

@interface VisualizeStagingViewController ()

@end

@implementation VisualizeStagingViewController
@synthesize periodPicker;


-(void)visualize:(id)sender{
    NSLog(@"%d", [self.periodPicker selectedSegmentIndex]);
    
    NSDate *endDate = [NSDate date];
    NSDate *startDate;
    NSInteger segementIndex = [self.periodPicker selectedSegmentIndex];
    if (segementIndex == kDailyIndex) {
        startDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
    }
    else if (segementIndex == kWeeklyIndex){
        startDate = [NSDate dateWithTimeIntervalSinceNow:-604800];
    }
    else if (segementIndex == kMonthlyIndex){
        startDate = [NSDate dateWithTimeIntervalSinceNow:-2592000];
    }
    NSArray *dataByDateArray = [NSArray arrayWithArray:[self dateArrayFrom:startDate to:endDate]];
    
    // turn data by data array into htmlbuilderarray
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSDictionary *entry in dataByDateArray) {
        NSLog(@"%@", [entry description]);
        for (NSDictionary *aTrait in [entry objectForKey:@"traits"]){
            NSDictionary *trait = [NSDictionary dictionaryWithDictionary:[[entry objectForKey:@"traits"] objectForKey:aTrait]];
            NSString *traitName = (NSString *)aTrait;
            if (![result objectForKey:traitName]) {
                [result setObject:[[NSMutableArray alloc] init] forKey:traitName];
            }
            NSDictionary *aResult = [NSDictionary dictionaryWithObjectsAndKeys: [entry objectForKey:@"date"], @"date", traitName, @"traitname", [trait objectForKey:@"notes"], @"note",  [trait objectForKey:@"rating"], @"rating",nil];
            [[result objectForKey:traitName] addObject: aResult];
        }
    }
    NSLog(@"%@", [result description]);
}

-(NSArray *)dateArrayFrom:(NSDate *)startDate to:(NSDate *)endDate{
    
    AppDelegate *myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDbDateFormat];
    
    // Result will store the information needed to create the graph
    NSMutableArray *result = [[NSMutableArray alloc] init];
    // Find out which traits were picked to be visualized
    NSArray *traitsToVisualize = [myApp activeTraits];
    // Set up a "calendar" to be able to iterate through the range of dates
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay: 1];
    
    // We will use idValue to keep track of the order of the dates in the dictionary
    NSNumber *idValue = [NSNumber numberWithInt:0];
    // Iterate through the date range, incrementing startDate everytime until it matches endDate
    while ([[df stringFromDate:startDate] intValue] <= [[df stringFromDate:endDate] intValue]){
        // Set up a dictionary that with a date key and trait key, date points to string date and traits points to dictionary with trait names as keys and values of a dictionary with keys notes and ratings pointing to any notes and the rating
        NSMutableDictionary *currentDateObject = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:idValue, [[myApp stringDateFormatter] stringFromDate:startDate], [[NSMutableDictionary alloc] init], nil] forKeys:[NSArray arrayWithObjects: @"id",@"date", @"traits", nil]];
        
        // Current date has all the entries for the date we are iterating over
        NSDictionary *currentDate = [[myApp allEntries] objectForKey:[df stringFromDate:startDate]];
        // For every trait we'd like to visualize
        for (id trait in traitsToVisualize) {
            // Pick out that trait from the day's entries
            NSDictionary *currentTrait = [currentDate objectForKey:trait];
            // Add it the currentDateObject
            if (currentTrait) {
                [[currentDateObject objectForKey:@"traits"] setObject:currentTrait forKey:trait];
            }
        }
        // Once we are done getting the entries for the traits we want to visualize, add it to the results and increment the date
        [result addObject:currentDateObject];
        startDate = [gregorian dateByAddingComponents:comp toDate:startDate options:0];
        // Increment idValue to help keep track of the order
        idValue = [NSNumber numberWithInt:[idValue intValue] + 1];
    }
    
    // Result has the information needed to create the chart
    return result;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setPeriodPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"Cell";
    
    if ([indexPath section] == 0) {
        CellIdentifier = @"button"; 
    }
    else if ([indexPath section] == 1){
        CellIdentifier = @"segmentedController";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([indexPath section] == 0){
        cell.textLabel.text = @"See the Graph!";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    if ([indexPath section] == 1){
        self.periodPicker = (UISegmentedControl *)[cell.contentView viewWithTag:2];
    }
        
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        [self visualize:self];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
