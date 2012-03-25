//
//  NoteViewController.m
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "AppDelegate.h"
#import "Trait.h"
#import "Entry.h"

@interface NoteViewController ()

@end

@implementation NoteViewController
@synthesize textView;
@synthesize cancelButton;
@synthesize doneButton;
@synthesize navBarTitle;

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
	// Do any additional setup after loading the view.
    [textView becomeFirstResponder];
    AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
    Entry *currentEntry = [myApp currentEntry];
    if ([currentEntry valueForKey:@"notes"]) {
        self.textView.text = [currentEntry valueForKey:@"notes"];
    }
    else {
        self.textView.text = @"";
    }
    
    navBarTitle.title = [NSString stringWithFormat:@"%@ Notes",[[myApp currentTrait] valueForKey:@"name"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender tag] == 1){
        AppDelegate *myApp = [[UIApplication sharedApplication] delegate];
        Entry *currentEntry = [myApp currentEntry];
        [currentEntry setValue:self.textView.text forKey:@"notes"];
    }
}

- (IBAction)buttonClick:(id)sender{
    // Send alert to make sure cancel is wanted
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to cancel this note?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [alert showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Remove the note view controller to delete the current note, else leave it there to continue editing
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [self performSegueWithIdentifier:@"backToRating" sender:[self cancelButton]];
    }
}

- (void)viewDidUnload
{
    [self setCancelButton:nil];
    [self setDoneButton:nil];
    [self setNavBarTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end