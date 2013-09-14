//
//  TCStepsDelegate.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/14/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDirectionsStep;
@class TCStepsViewController;

@protocol TCStepsDelegate <NSObject>

/**
 * <#Description#>
 *
 * @param stepsViewController <#stepsViewController description#>
 */
- (void)stepsViewControllerDidSelectMyLocation:(TCStepsViewController *)stepsViewController;

/**
 * <#Description#>
 *
 * @param stepsViewController <#stepsViewController description#>
 */
- (void)stepsViewControllerDidSelectDestination:(TCStepsViewController *)stepsViewController;

/**
 * Tells the delegate that the specified step was selected.
 *
 * @param stepsViewController The `TCStepsViewController` instance that sent this message.
 * @param step The step that was selected.
 */
- (void)stepsViewController:(TCStepsViewController *)stepsViewController
              didSelectStep:(TCDirectionsStep *)step;

@end
