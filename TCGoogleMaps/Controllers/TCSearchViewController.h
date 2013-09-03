//
//  TCSearchViewController.h
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/19/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 View Controller to search for nearby places using Google Places API.
 */
@interface TCSearchViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,
     CLLocationManagerDelegate>

@end
