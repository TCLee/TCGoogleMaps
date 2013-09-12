//
//  TCDirectionsViewController.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/22/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCStepsViewController.h"
#import "TCGoogleDirections.h"

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
 * Dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender;

@end

@implementation TCStepsViewController

#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.steps ? self.steps.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"TCDirectionsStepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];    
    
    TCDirectionsStep *step = self.steps[indexPath.row];
    cell.textLabel.text = step.instructions;
    cell.detailTextLabel.text = step.distance.text;    
    return cell;
}

#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the instructions from the selected step.
    TCDirectionsStep *step = self.steps[indexPath.row];
    
    // The actual label's width may differ from the preferred width because
    // of the way the text is layout.
    CGFloat preferredLabelWidth = tableView.frame.size.width - kCellContentMargin;
    
    // Calculate the expected label size with the given constraints.
    CGSize labelSize = [step.instructions sizeWithFont:[UITableViewCell defaultTextLabelFont]
                                     constrainedToSize:CGSizeMake(preferredLabelWidth, CGFLOAT_MAX)
                                         lineBreakMode:NSLineBreakByWordWrapping];
    
    // Make sure that the calculated row height is not less than the default
    // minimum height.
    return MAX(kCellDefaultHeight, labelSize.height + kCellContentMargin);
}

#pragma mark IBAction Methods

/*
 User press the Done button to dismiss this modal view controller.
 */
- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
