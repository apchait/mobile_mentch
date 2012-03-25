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
    NSLog(@"%@", [segue identifier]);
    // if sending to rating view, make my notes myApp's notes
    if ([[segue identifier] isEqualToString:@"toNoteView"]) {
        if ([notes.text isEqualToString: @"Add Notes Here..."]) {
            myApp.notes = @"";            
        }
        else {
            myApp.notes = [notes text];
        }
    }
    // if finishing up, delete myApp's notes
    else if ([[segue identifier] isEqualToString:[NSString stringWithFormat:@"toMainView"]]){
        myApp.currentEntry = [[Entry alloc] init];
        NSLog(@"%@",[myApp.currentTrait valueForKey:@"name"]);
        //myApp.currentEntry.traitName = @"HI";
        myApp.currentEntry.traitName = [NSString stringWithFormat:@"%@", [myApp.currentTrait valueForKey:@"name"]];
        if ([myApp.notes isEqualToString:@"Add Notes Here..."]) {
            myApp.currentEntry.notes = [NSString stringWithFormat:@""];
        }
        else{
            myApp.currentEntry.notes = [NSString stringWithFormat:@"%@", myApp.notes];
        }
        
        myApp.notes = @"Add Notes Here...";
        
        if ([star5 isSelected]) {
            myApp.currentEntry.rating = [NSNumber numberWithInt:5];   
        }
        else if ([star4 isSelected]){
            myApp.currentEntry.rating = [NSNumber numberWithInt:4];
        }
        else if ([star3 isSelected]){
            myApp.currentEntry.rating = [NSNumber numberWithInt:3];
        }
        else if ([star2 isSelected]){
            myApp.currentEntry.rating = [NSNumber numberWithInt:2];
        }
        else if ([star1 isSelected]){
            myApp.currentEntry.rating = [NSNumber numberWithInt:1];
        }
        else {
            myApp.currentEntry.rating = [NSNumber numberWithInt:0];
        }
        // save here
        [myApp saveCurrentEntry];
    }
}
-(IBAction)starPressed:(id)sender{
    NSArray *stars = [[NSArray alloc] initWithObjects:star1, star2, star3, star4, star5, nil];
    BOOL foundSender = NO;
    NSLog(@"Pressed");
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
    UIButton *button = sender;
    CGRect rect = [button frame];
    NSLog(@"Swiped");
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
    if (myApp.notes) {
        [notes setText:myApp.notes];
    }
    // Check if there are already notes for today and set them to myApp.notes
    NSNumber *rating = [[[myApp.allEntries valueForKey:[myApp.currentTrait valueForKey:@"name"]] valueForKey:[myApp dateKey]] valueForKey:@"rating"];
    
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
