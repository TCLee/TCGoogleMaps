//
//  TCDirectionsViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCPlace;

/**
 * Controller for the table view that displays the steps of a route.
 */
@interface TCStepsViewController : UITableViewController

/**
 * <#Description#>
 *
 * @param steps <#steps description#>
 * @param place <#place description#>
 */
- (void)setSteps:(NSArray *)steps destination:(TCPlace *)place;

@end
