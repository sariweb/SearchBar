//
//  ViewController.h
//  SearchBar
//
//  Created by SA on 08/08/2018.
//  Copyright © 2018 SA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterControl;
- (IBAction)actionFilter:(UISegmentedControl *)sender;

@end

