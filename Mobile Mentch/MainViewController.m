//
//  MainViewController.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Trait.h"
#import "Entry.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController, myApp;

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.myApp traits] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"CustomCellID";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID];
	}
	
    // Get the trait list that was loaded in the App Delegate and set up the table view cells
    NSDictionary *traits = [[NSDictionary alloc] initWithDictionary:[myApp traits]];
    NSDictionary *currentTrait = [traits objectForKey:[[traits allKeys] objectAtIndex:[indexPath row]]];
    cell.textLabel.text = [currentTrait objectForKey:@"name"];
    cell.detailTextLabel.text = [currentTrait objectForKey:@"description"];
    // Some cells need special icon names to deal with a / or : in the filename
    if ([[currentTrait valueForKey:@"icon"] isEqualToString:[NSString stringWithFormat:@""]]) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentTrait valueForKey:@"name"]]];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentTrait valueForKey:@"icon"]]];
    }
    
    // If an entry exists for today, use a checkmark
    if([[[myApp allEntries] objectForKey:cell.textLabel.text] valueForKey:[myApp dateKey]] && [[[[[myApp allEntries] objectForKey:cell.textLabel.text] valueForKey:[myApp dateKey]] valueForKey:@"rating"] intValue] != 0){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Get today's entry for the trait selected
    NSString *traitName = [[[self.tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    myApp.currentTrait = [myApp.traits valueForKey:traitName];
    myApp.currentEntry = [[myApp.allEntries valueForKey:traitName] valueForKey:[myApp dateKey]];
    if (!myApp.currentEntry) {
        myApp.currentEntry = [[Entry alloc] init];
    }
    return indexPath;
}

#pragma mark - Regular View methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myApp = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
