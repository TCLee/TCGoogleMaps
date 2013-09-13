//
//  TCDirectionsViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStepsViewController.h"
#import "TCCellModel.h"

#import "TCGoogleDirections.h"
#import "TCGooglePlaces.h"

#import <QuartzCore/QuartzCore.h>

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
 * The default font is cached, so calling this method repeatedly is
 * still efficient.
 */
+ (UIFont *)defaultTextLabelFont;

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
 * Dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender;

@end

@implementation TCStepsViewController

#pragma mark Cell Models

- (void)setSteps:(NSArray *)theSteps
{
    // Only recreate the model objects, if the steps have changed.
    if (_steps != theSteps) {
        _steps = [theSteps copy];
        _cellModels = [self createCellModelsWithSteps:_steps];
    }
}

- (void)setSteps:(NSArray *)theSteps destination:(TCPlace *)theDestination
{
    // Place details of the destination.
    if (_destination != theDestination) {
        _destination = theDestination;
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

//TODO: We also need to take into account the subtitle label of the cell!
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Get the instructions from the selected step.
//    TCDirectionsStep *step = self.steps[indexPath.row];
//    
//    // The actual label's width may differ from the preferred width because
//    // of the way the text is layout.
//    CGFloat preferredLabelWidth = tableView.frame.size.width - kCellContentMargin;
//    
//    // Calculate the expected label size with the given constraints.
//    CGSize labelSize = [step.instructions sizeWithFont:[UITableViewCell defaultTextLabelFont]
//                                     constrainedToSize:CGSizeMake(preferredLabelWidth, CGFLOAT_MAX)
//                                         lineBreakMode:NSLineBreakByWordWrapping];
//    
//    // Make sure that the calculated row height is not less than the default
//    // minimum height.
//    return MAX(kCellDefaultHeight, labelSize.height + kCellContentMargin);
//}

#pragma mark IBAction Methods

/*
 User press the Done button to dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
