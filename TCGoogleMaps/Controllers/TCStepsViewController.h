//
//  TCDirectionsViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCPlace;
@protocol TCStepsDelegate;

/**
 * Table view controller that displays the steps of a route.
 */
@interface TCStepsViewController : UITableViewController

/**
 * The object that acts as the delegate to this view controller.
 * Usually, this will be the presenting view controller.
 */
@property (nonatomic, weak) id<TCStepsDelegate> delegate;

/**
 * Set the route's steps and the destination's place details.
 * This will update the view accordingly.
 *
 * @param steps The array of TCDirectionsStep objects.
 * @param place The place details of the destination.
 */
- (void)setSteps:(NSArray *)steps destination:(TCPlace *)place;

@end
