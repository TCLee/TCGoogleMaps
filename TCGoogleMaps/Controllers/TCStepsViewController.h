//
//  TCDirectionsViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Controller for the table view that displays the instructions 
 * for the route.
 */
@interface TCStepsViewController : UITableViewController

/**
 * The array of TCDirectionsStep objects of the route.
 * Each TCDirectionsStep object will contain the instructions for each
 * step of the route.
 */
@property (nonatomic, copy) NSArray *steps;

@end
