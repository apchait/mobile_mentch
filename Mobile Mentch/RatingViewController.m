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
@interface RatingViewController ()

@end

@implementation RatingViewController
@synthesize myApp, traitTitle, traitDescription, traitImage, notes, navBarTitle, star1, star2, star3, star4, star5;

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
    
    
    /*
    //[sender setHighlightedImage:[UIImage imageNamed:@"star-red256.png"]];
    if([sender isSelected]){
        // un select self and everyone right
        BOOL foundSender = NO;
        for(UIButton *button in stars){
            if (button == sender){
                [button setSelected:NO];
                foundSender = YES;
            }
            else if(foundSender){
                // Not at sender yet
                [button setSelected:YES];
            }
            else {
                [button setSelected:NO];
            }
        }
    }
    else{
        // select self and everyone left
        BOOL foundSender = NO;
        for(UIButton *button in stars){
            if (button == sender){
                [button setSelected:YES];
                foundSender = YES;
            }
            else if(foundSender){
                // Not at sender yet
                [button setSelected:YES];
            }
            else {
                [button setSelected:NO];
            }
            
        }
    }
     */
}
-(IBAction)starSwiped:(id)sender{
    UIButton *button = sender;
    CGRect rect = [button frame];
    NSLog(@"Swiped");
}
#pragma mark TextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([[textView text] isEqualToString:@"Add Notes Here..."]){
        [textView setText:@""];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([[textView text] isEqualToString:@""]){
        [textView setText:@"Add Notes Here..."];
    }
}

- (BOOL)textViewShouldReturn:(UITextView *)textView {
    // Close the keyboard when return is touched
    [textView resignFirstResponder];
    return NO;
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
    
    // Set up the stars

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
