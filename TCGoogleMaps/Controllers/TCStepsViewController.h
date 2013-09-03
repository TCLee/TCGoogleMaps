//
//  TCDirectionsViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCDirections.h"

/*
 Controller for the table view that displays the text directions.
 */
@interface TCStepsViewController : UITableViewController

@property (nonatomic, strong) TCDirectionsRoute *route;

@end
