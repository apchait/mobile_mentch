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

-(void)visualizeButton:(id)sender{
    // print out all traits in array from start to end
    NSArray *ar = [[NSArray alloc] initWithObjects:@"Confidence",@"Approval",@"Attentiveness", nil];
    NSDateFormatter *dbDateFormat = [[NSDateFormatter alloc] init];
    [dbDateFormat setDateFormat:kDbDateFormat];
    NSString *startDate = [dbDateFormat stringFromDate:[self.dateFormat dateFromString: [FromUntilDateSegments titleForSegmentAtIndex:0]]];
    NSString *endDate= [dbDateFormat stringFromDate:[self.dateFormat dateFromString:[FromUntilDateSegments titleForSegmentAtIndex:1]]];

    [self dateArrayFrom:[self.dateFormat dateFromString: [FromUntilDateSegments titleForSegmentAtIndex:0]] to:[self.dateFormat dateFromString:[FromUntilDateSegments titleForSegmentAtIndex:1]]];
}

-(NSArray *)dateArrayFrom:(NSDate *)startDate to:(NSDate *)endDate{
    
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDbDateFormat];
    NSLog(@"%@",[[myApp allEntries] objectForKey:[df stringFromDate:endDate]]);
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *traitsToVisualize = [[NSArray alloc] initWithObjects:@"Confidence",@"Approval",@"Attentiveness", nil];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay: 1];
    
    while ([[df stringFromDate:startDate] intValue] <= [[df stringFromDate:endDate] intValue]){
        // Add items here
        NSMutableDictionary *objectToAdd = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self.dateFormat stringFromDate:startDate], [[NSMutableDictionary alloc] init], nil] forKeys:[NSArray arrayWithObjects: @"date", @"traits", nil]];
        for (id trait in traitsToVisualize) {
            [[objectToAdd objectForKey:@"traits"] setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], @"Notes Here", nil] forKeys:[NSArray arrayWithObjects:@"rating", @"notes",nil ]] forKey:trait];
        }
        [result addObject:objectToAdd];
        startDate = [gregorian dateByAddingComponents:comp toDate:startDate options:0];
    }

    NSLog(@"%@", [result description]);
    return result;
}

-(void)saveButton:(id)sender{
    NSLog(@"Done Picking Date!");
    NSLog(@"%@", [self.datePicker.date description]);
    NSString *dateString = [self.dateFormat stringFromDate:self.datePicker.date];
    // set the date segement to the date in the picker
    [self.FromUntilDateSegments setTitle:dateString forSegmentAtIndex:[activeSegment intValue]];
    [self.datePicker setHidden:YES];
    [[self.navBar topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(visualizeButton:)]];
    
}

- (IBAction)datePicker:(id)sender{
    self.activeSegment = [NSNumber numberWithInt:[sender selectedSegmentIndex]];

    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    [self.datePicker setDate:[self.dateFormat dateFromString:[self.FromUntilDateSegments titleForSegmentAtIndex:[activeSegment intValue]]]];
    
//    UINavigationBar *nav = 
    [[self.navBar topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton:)]];
    
    [self.datePicker setHidden:NO];


}



@end
