//
//  RatingViewController.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingViewController.h"
#import "AppDelegate.h"
#import "Trait.h"
#import "Entry.h"
@interface RatingViewController ()

@end

@implementation RatingViewController
@synthesize myApp, traitTitle, traitDescription, traitImage, notes, navBarTitle, star1, star2, star3, star4, star5;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // if sending to rating view, make my notes myApp's notes
    if ([[segue identifier] isEqualToString:@"toNoteView"]) {
    
    }
    // if finishing up, save and clean up
    else if ([[segue identifier] isEqualToString:[NSString stringWithFormat:@"toMainView"]]){
        Entry *currentEntry = [myApp currentEntry];
        
        if ([star5 isSelected]) {
            [currentEntry setValue:[NSNumber numberWithInt:5] forKey:@"rating"];
        }
        else if ([star4 isSelected]){
            [currentEntry setValue:[NSNumber numberWithInt:4] forKey:@"rating"];
        }
        else if ([star3 isSelected]){
            [currentEntry setValue:[NSNumber numberWithInt:3] forKey:@"rating"];
        }
        else if ([star2 isSelected]){
            [currentEntry setValue:[NSNumber numberWithInt:2] forKey:@"rating"];
        }
        else if ([star1 isSelected]){
            [currentEntry setValue:[NSNumber numberWithInt:1] forKey:@"rating"];
        }
        else {
            [currentEntry setValue:[NSNumber numberWithInt:0] forKey:@"rating"];
        }
        // save here
        [myApp saveCurrentEntry];
    }
}
-(IBAction)starPressed:(id)sender{
    NSArray *stars = [[NSArray alloc] initWithObjects:star1, star2, star3, star4, star5, nil];
    BOOL foundSender = NO;
    for (NSUInteger i = 0; i<[stars count]; i++) {
        UIButton *button = [stars objectAtIndex:i];
        if (button == sender) {
            foundSender = YES;
            if ([sender isSelected]){
                // if sender to the right is selected, leave selected
                if (![[stars objectAtIndex:i + 1] isSelected]) {
                    [sender setSelected:NO];
                }
                else {
                    [sender setSelected:YES];
                }
            }
            else {
                [sender setSelected:YES];
            }
        }
        else if (!foundSender) {
            [button setSelected:YES];
        }
        else {
            [button setSelected:NO];
        }
    }
    
}
-(IBAction)starSwiped:(id)sender{
    //UIButton *button = sender;
    //CGRect rect = [button frame];
}

#pragma mark Loadup Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    myApp = [[UIApplication sharedApplication] delegate];
    Trait *currentTrait = [myApp currentTrait];
    Entry *currentEntry = [myApp currentEntry];
    [navBarTitle setTitle:[currentTrait valueForKey:@"name"]];
    if ([[currentTrait valueForKey:@"icon"] isEqualToString:@""]){
        [traitImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentTrait valueForKey:@"name"]]]];
    }
    else {
        [traitImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentTrait valueForKey:@"icon"]]]];
    }
    
    if ([[currentTrait valueForKey:@"customDescription"] isEqualToString: [NSString stringWithFormat:@""]]){
        [traitDescription setText:[currentTrait valueForKey:@"description"]];
    }
    else{
        [traitDescription setText:[currentTrait valueForKey:@"customDescription"]];
    }
    
    // Set up the notes
    if ([currentEntry valueForKey:@"notes"]){
        [notes setText:[currentEntry valueForKey:@"notes"]];
    }
    else{
        [notes setText:@"Add Notes Here..."];
    }
    NSNumber *rating;
    if ([currentEntry valueForKey:@"rating"]){
        rating = [currentEntry valueForKey:@"rating"];
    }
    else {
        rating = [NSNumber numberWithInt:0];
    }
    
    if ([rating intValue] == 1) {
        [self starPressed:star1];
    }
    else if ([rating intValue] == 2) {
        [self starPressed:star2];
    }
    else if ([rating intValue] == 3) {
        [self starPressed:star3];
    }
    else if ([rating intValue] == 4) {
        [self starPressed:star4];
    }
    else if ([rating intValue] == 5) {
        [self starPressed:star5];
    }
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
