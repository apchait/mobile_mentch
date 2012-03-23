//
//  RatingViewController.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface RatingViewController : UITableViewController <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, retain) AppDelegate *myApp;
@property (nonatomic, retain) IBOutlet UILabel *traitTitle;
@property (nonatomic, retain) IBOutlet UITextView *traitDescription, *notes;
@property (nonatomic, retain) IBOutlet UINavigationItem *navBarTitle;
@property (nonatomic, retain) IBOutlet UIImageView *traitImage;
@property (nonatomic, retain) IBOutlet UIButton *star1, *star2, *star3, *star4, *star5;

-(IBAction)starPressed:(id)sender;
-(IBAction)starSwiped:(id)sender;

@end
