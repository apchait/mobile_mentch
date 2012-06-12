//
//  VisualizeStagingViewController.h
//  Mobile Mentch
//
//  Created by ARIEL CHAIT on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDailyIndex 3
#define kWeeklyIndex 2
#define kMonthlyIndex 1
#define kYearlyIndex 0

@interface VisualizeStagingViewController : UITableViewController
@property (weak, nonatomic) UISegmentedControl *periodPicker;

-(void)visualize:(id)sender;
-(NSArray *)dateArrayFrom:(NSDate *)startDate to:(NSDate *)endDate;
@end
