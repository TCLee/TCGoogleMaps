//
//  TCDirectionsViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStepsViewController.h"
#import "TCStepsDelegate.h"
#import "TCCellModel.h"

#import "TCGoogleDirections.h"
#import "TCGooglePlaces.h"

/**
 * The space between the text label and the cell.
 */
static CGFloat const kCellContentMargin = 20.0f;

/**
 * The default height of a cell in the table view.
 */
static CGFloat const kCellDefaultHeight = 80.0f;

#pragma mark UITableViewCell Category

@interface UITableViewCell (TextLabelFont)

/**
 * Returns the default font used by the cell's text label.
 * The font is cached, so calling this method repeatedly is
 * still efficient.
 */
+ (UIFont *)defaultTextLabelFont;

/**
 * Returns the default font used by the cell's detail text label.
 * The font is cached, so calling this method repeatedly is
 * still efficient.
 */
+ (UIFont *)defaultDetailTextLabelFont;

@end

@implementation UITableViewCell (TextLabelFont)

+ (UIFont *)defaultTextLabelFont
{
    static UIFont *_cellTextLabelFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellTextLabelFont = [UIFont systemFontOfSize:15.0f];
    });
    return _cellTextLabelFont;    
}

+ (UIFont *)defaultDetailTextLabelFont
{
    static UIFont *_cellDetailTextLabelFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellDetailTextLabelFont = [UIFont systemFontOfSize:13.0f];
    });
    return _cellDetailTextLabelFont;
}

@end

#pragma mark - TCStepsViewController

@interface TCStepsViewController ()

/**
 * The array of model objects to be drawn on the table cells.
 */
@property (nonatomic, copy, readonly) NSArray *cellModels;

/**
 * The array of TCDirectionsStep objects of the route.
 * Each TCDirectionsStep object will contain the instructions for each
 * step of the route.
 */
@property (nonatomic, copy, readonly) NSArray *steps;

/**
 * Place details for the destination.
 */
@property (nonatomic, strong, readonly) TCPlace *destination;

/**
 * User taps the 'Done' button to dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender;

@end

@implementation TCStepsViewController

#pragma mark Cell Models

- (void)setSteps:(NSArray *)theSteps destination:(TCPlace *)place
{
    // Place details of the destination.
    if (_destination != place) {
        _destination = place;
    }
    
    // Only recreate the model objects, if the steps have changed.
    if (_steps != theSteps) {
        _steps = [theSteps copy];
        _cellModels = [self createCellModelsWithSteps:_steps];
    }
}

/**
 * Creates and returns an array of TCCellModel objects.
 *
 * @param theSteps The array of TCDirectionsStep objects that will be added
 *                 as TCCellModel objects to the resulting array.
 */
- (NSArray *)createCellModelsWithSteps:(NSArray *)theSteps
{
    NSMutableArray *myCellModels = [[NSMutableArray alloc] initWithCapacity:theSteps.count + 2];
    
    // First cell model object is the start location (origin).
    TCCellModel *firstCellModel = [[TCCellModel alloc] initWithText:@"My Location"
                                                         detailText:nil
                                                              image:[UIImage imageNamed:@"turn_my_location"]];
    [myCellModels addObject:firstCellModel];
    
    // Convert the TCDirectionsStep objects to our cell model objects.
    for (TCDirectionsStep *step in theSteps) {
        TCCellModel *cellModel = [[TCCellModel alloc] initWithText:step.instructions
                                                        detailText:step.distance.text
                                                             image:nil];
        // Store a reference to the TCDirectionsStep object, so that we
        // can retrieve it later.
        cellModel.userData = step;
        
        [myCellModels addObject:cellModel];
    }
    
    // Last cell model object is the destination.
    TCCellModel *lastCellModel = [[TCCellModel alloc] initWithText:self.destination.name
                                                        detailText:self.destination.address
                                                             image:[UIImage imageNamed:@"turn_arrive"]];
    [myCellModels addObject:lastCellModel];
        
    return [myCellModels copy];
}

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModels ? self.cellModels.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TCDirectionsStepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    TCCellModel *model = self.cellModels[indexPath.row];
    cell.textLabel.text = model.text;
    cell.detailTextLabel.text = model.detailText;
    cell.imageView.image = model.image;
    
    return cell;
}

#pragma mark Table View Delegate

/**
 * Returns the last row in a given section of a table view.
 */
#define LAST_ROW ([tableView numberOfRowsInSection:indexPath.section] - 1)

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use a different color for the first and last row representing the origin and destination.
    if (0 == indexPath.row || LAST_ROW == indexPath.row) {
        [cell setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    } else {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
}

// The row height has to be dynamic because of the long text contents
// that will word wrap.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCCellModel *cellModel = self.cellModels[indexPath.row];    
    
    // The actual label's width may differ from the preferred width because
    // of the way the text is layout.
    CGFloat preferredLabelWidth = tableView.frame.size.width - kCellContentMargin;
    // We want a fixed width for the label. The height can grow as needed.
    CGSize preferredLabelSize = CGSizeMake(preferredLabelWidth, CGFLOAT_MAX);
    
    // The expected size for the cell's text label.
    CGSize textLabelSize = [cellModel.text sizeWithFont:[UITableViewCell defaultTextLabelFont]
                                      constrainedToSize:preferredLabelSize
                                          lineBreakMode:NSLineBreakByWordWrapping];

    // The expected size for the cell's detail text label.
    CGSize detailTextLabelSize = [cellModel.detailText sizeWithFont:[UITableViewCell defaultDetailTextLabelFont]
                                                  constrainedToSize:preferredLabelSize
                                                      lineBreakMode:NSLineBreakByWordWrapping];
    
    // Total up the labels heights and margins together to get the cell height.
    CGFloat cellHeight = textLabelSize.height + detailTextLabelSize.height + kCellContentMargin;
    
    // Make sure that the calculated cell's height is not less than the default
    // minimum height.
    return MAX(kCellDefaultHeight, cellHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Dismiss the modal view controller here rather than in the delegate
    // because it's a common behavior for all the delegate's messages.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (0 == indexPath.row) {
        // Selected My Location (origin)
        [self.delegate stepsViewControllerDidSelectMyLocation:self];
    } else if (LAST_ROW == indexPath.row) {
        // Selected destination
        [self.delegate stepsViewControllerDidSelectDestination:self];
    } else {
        // Selected the steps between origin and destination.
        TCCellModel *cellModel = self.cellModels[indexPath.row];
        TCDirectionsStep *step = (TCDirectionsStep *)cellModel.userData;        
        [self.delegate stepsViewController:self didSelectStep:step];
    }
}

#pragma mark IBAction Methods

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
