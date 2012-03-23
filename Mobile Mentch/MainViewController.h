//
//  MainViewController.h
//  Mobile Mentch
//
//  Created by Ariel Chait on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
@class AppDelegate;

@interface MainViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (nonatomic, retain) AppDelegate *myApp;

@end
