//
//  TCCellModel.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/13/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * The model object that stores the contents for a generic 
 * UITableViewCell instance.
 */
@interface TCCellModel : NSObject

/**
 * The string to be displayed on a cell's text label.
 */
@property (nonatomic, copy, readonly) NSString *text;

/**
 * The string to be displayed on a cell's detail text label.
 */
@property (nonatomic, copy, readonly) NSString *detailText;

/**
 * The image to be displayed on a cell's image view.
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 * You can use this property to associate any arbitrary object with this 
 * cell model.
 */
@property (nonatomic, strong) id userData;

/**
 * Initializes the table cell's model with the given contents and returns it.
 *
 * @param text       The string to be displayed on a cell's text label.
 * @param detailText The string to be displayed on a cell's detail text label.
 * @param image      The image to be displayed on a cell's image view.
 *
 * @return An initialized TCCellModel object or nil if the model object could not be created.
 */
- (id)initWithText:(NSString *)text detailText:(NSString *)detailText image:(UIImage *)image;

@end
