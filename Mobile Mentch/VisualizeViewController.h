//
//  VisualizeViewController.h
//  Mobile Mentch
//
//  Created by ARIEL CHAIT on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisualizeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *FromUntilDateSegments;
@property (nonatomic,retain) NSDateFormatter *dateFormat;


@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) NSNumber *activeSegment;


- (IBAction)datePicker:(id)sender;
- (void)saveButton:(id)sender;
-(NSArray *)dateArrayFrom:(NSDate *)startDate to:(NSDate *)endDate;

@end
