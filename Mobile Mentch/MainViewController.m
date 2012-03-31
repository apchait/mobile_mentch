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
@synthesize editButton;

@synthesize flipsidePopoverController = _flipsidePopoverController, myApp;

#pragma mark - UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 1;
    }
    else{
        return [[self.myApp traits] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *kCustomCellID;
    if ([indexPath section] == 0) {
        kCustomCellID = @"CoinCell";
    }
    else {
        kCustomCellID = @"CustomCellID";
    }
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID];
	}
	
    if ([indexPath section] == 0) {
        // Set Up Coins
        cell.textLabel.text = @"Mentch Novice";

    }
    else {
        NSUInteger row = [indexPath row];
        // Get the trait list that was loaded in the App Delegate and set up the table view cells
        NSDictionary *traits = [[NSDictionary alloc] initWithDictionary:[myApp traits]];
        NSDictionary *currentTrait;
        
        // Use the traitOrder to set up
        for (NSString *trait in [myApp traitsOrder]) {
            if([[[[myApp traitsOrder] valueForKey:trait] valueForKey:@"index"] intValue] == row){
                currentTrait = [traits objectForKey:trait];
            }
        }
        
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
        if ([[[myApp todaysEntries] objectForKey:cell.textLabel.text] valueForKey:@"rating"] != 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        /*
        if([[[myApp allEntries] objectForKey:cell.textLabel.text] valueForKey:[myApp dateKey]] && [[[[[myApp allEntries] objectForKey:cell.textLabel.text] valueForKey:[myApp dateKey]] valueForKey:@"rating"] intValue] != 0){
            NSLog(@"%@",cell.textLabel.text);

        }*/
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

-(IBAction)edit:(id)sender{
    self.editing = !self.editing;
    if (self.editing) {
        editButton.title = @"Done";
        editButton.style = UIBarButtonItemStyleDone;
    }
    else {
        [myApp writeTraitsOrderFile];
        editButton.title = @"Edit";
        editButton.style = UIBarButtonItemStylePlain;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section] == 0) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dont move the coin cell
    if ([indexPath section] == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSLog(@"From %d", [fromIndexPath row]);
    NSLog(@"To %d", [toIndexPath row]);
    NSLog(@"From %@", [[[tableView cellForRowAtIndexPath:fromIndexPath] textLabel] text]);
    NSLog(@"To %@", [[[tableView cellForRowAtIndexPath:toIndexPath] textLabel] text]);
    NSString *fromTrait = [[[tableView cellForRowAtIndexPath:fromIndexPath] textLabel] text];
    //NSString *toTrait = [[[tableView cellForRowAtIndexPath:toIndexPath] textLabel] text];
    
    if ([fromIndexPath row] < [toIndexPath row]) {
        for (NSUInteger i = [fromIndexPath row] + 1; i <= [toIndexPath row]; i++) {
            for (id trait in myApp.traitsOrder){
                if ([[[myApp.traitsOrder valueForKey:trait] valueForKey:@"index"] intValue] == i) {
                    [[myApp.traitsOrder valueForKey:trait] setValue:[NSNumber numberWithInt:i-1] forKey:@"index"];
                }
            }
        }
    }
    else {
        for (NSInteger i = [fromIndexPath row] - 1; i >= [toIndexPath row]; i--) {
            for (id trait in myApp.traitsOrder){
                if ([[[myApp.traitsOrder valueForKey:trait] valueForKey:@"index"] intValue] == i) {
                    [[myApp.traitsOrder valueForKey:trait] setValue:[NSNumber numberWithInt:i+1] forKey:@"index"];
                }
            }
        }
    }
    [[[myApp traitsOrder] valueForKey:fromTrait] setValue:[NSNumber numberWithInt:[toIndexPath row]] forKey:@"index"];
    NSLog(@"%@",[[myApp traitsOrder] description]);

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
    [self setEditButton:nil];
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
