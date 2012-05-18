//
//  VisualizeViewController.m
//  Mobile Mentch
//
//  Created by ARIEL CHAIT on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VisualizeViewController.h"
#import "AppDelegate.h"
@interface VisualizeViewController ()

@end

@implementation VisualizeViewController
@synthesize datePicker;
@synthesize homeButton;
@synthesize navBar;
@synthesize FromUntilDateSegments,dateFormat, activeSegment;

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
    
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"MMM dd yyyy"];
    NSLog(@"%@",[[NSDate date] description]);
    NSString *dateString = [self.dateFormat stringFromDate:[NSDate date]];
    NSLog(@"%@",dateString);
    [self.FromUntilDateSegments setTitle:dateString forSegmentAtIndex:1];
    // set the from segment to 5 days ago
    dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-432000]];
    NSLog(@"%@",dateString);
    [self.FromUntilDateSegments setTitle:dateString forSegmentAtIndex:0];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker setHidden:YES];
    [[self.navBar topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(visualizeButton:)]];
}

- (void)viewDidUnload
{
    [self setFromUntilDateSegments:nil];
    [self setDatePicker:nil];
    [self setHomeButton:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)visualizeButton:(id)sender{
    NSDictionary *dataToVisualize = [self dateArrayFrom:[self.dateFormat dateFromString: [FromUntilDateSegments titleForSegmentAtIndex:0]] to:[self.dateFormat dateFromString:[FromUntilDateSegments titleForSegmentAtIndex:1]]];
    NSLog(@"%@", [dataToVisualize description]);
}

-(NSArray *)dateArrayFrom:(NSDate *)startDate to:(NSDate *)endDate{
    
    AppDelegate *myApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDbDateFormat];

    // Result will store the information needed to create the graph
    NSMutableArray *result = [[NSMutableArray alloc] init];
    // Find out which traits were picked to be visualized
//    NSArray *traitsToVisualize = [[NSArray alloc] initWithObjects:@"Contentment",@"Attentiveness", nil];
    NSArray *traitsToVisualize = [self selectedTraits];
    // Set up a "calendar" to be able to iterate through the range of dates
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay: 1];
    
    // We will use idValue to keep track of the order of the dates in the dictionary
    NSNumber *idValue = [NSNumber numberWithInt:0];
    // Iterate through the date range, incrementing startDate everytime until it matches endDate
    while ([[df stringFromDate:startDate] intValue] <= [[df stringFromDate:endDate] intValue]){
        // Set up a dictionary that with a date key and trait key, date points to string date and traits points to dictionary with trait names as keys and values of a dictionary with keys notes and ratings pointing to any notes and the rating
        NSMutableDictionary *currentDateObject = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:idValue, [self.dateFormat stringFromDate:startDate], [[NSMutableDictionary alloc] init], nil] forKeys:[NSArray arrayWithObjects: @"id",@"date", @"traits", nil]];

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

-(NSArray *)selectedTraits{
    // Returns an array of the the traits that have been selected to be visualized
    return [[NSArray alloc] initWithObjects:@"Contentment",@"Attentiveness", nil];
}

-(void)saveButton:(id)sender{
    // This closes the date picker and updates the UI to reflect which date was picked
    NSString *dateString = [self.dateFormat stringFromDate:self.datePicker.date];
    // set the date segement to the date in the picker
    [self.FromUntilDateSegments setTitle:dateString forSegmentAtIndex:[activeSegment intValue]];
    [self.datePicker setHidden:YES];
    [[self.navBar topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(visualizeButton:)]];
}

- (void)datePicker:(id)sender{
    // This sets up the datePicker and shows it
    self.activeSegment = [NSNumber numberWithInt:[sender selectedSegmentIndex]];

   // NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    [self.datePicker setDate:[self.dateFormat dateFromString:[self.FromUntilDateSegments titleForSegmentAtIndex:[activeSegment intValue]]]];

    // Change the play button to a done button to finish picking the date and call the saveButton method
    [[self.navBar topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton:)]];
    
    [self.datePicker setHidden:NO];
}



@end
