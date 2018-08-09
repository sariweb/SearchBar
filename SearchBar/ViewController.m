//
//  ViewController.m
//  SearchBar
//
//  Created by SA on 08/08/2018.
//  Copyright © 2018 SA. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Random.h"
#import "SASection.h"
#import "SAStudent.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *studentsArray;
@property (strong, nonatomic) NSArray *sectionsArray;
@property (strong, nonatomic) NSOperation *currentOperation;

@end

typedef enum {
    SAFilterBirthday,
    SAFilterFirstName,
    SAFilterLastName
} SAFilter;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 10000; i++) {
        SAStudent *student = [SAStudent randomStudent];
        [array addObject:student];
    }
    
    self.studentsArray = array;
    
    [self generateSectionsInBackgroundFromArray:self.studentsArray withFilter:self.searchBar.text];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateSectionsInBackgroundFromArray:(NSArray *)array withFilter:(NSString *)filterString {
    
    [self.currentOperation cancel];
    
    __weak ViewController *weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *sectionsArray = [weakSelf generateSectionsFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.tableView reloadData];
            
            self.currentOperation = nil;
        });
    }];
    
    [self.currentOperation start];
}

- (NSArray *)generateSectionsFromArray:(NSArray *)studentsArray withFilter:(NSString *)filterString {
    
    NSMutableArray *sectionsArray = [NSMutableArray array];
    
    NSSortDescriptor *sectionNameDescriptor = [NSSortDescriptor
                                               sortDescriptorWithKey:@"sectionName"
                                               ascending:YES];
    
    NSSortDescriptor *firstNameDescriptor = [NSSortDescriptor
                                             sortDescriptorWithKey:@"firstName"
                                             ascending:YES];
    
    NSSortDescriptor *lastNameDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"lastName"
                                            ascending:YES];
    
    NSSortDescriptor *birthDayDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"birthDay"
                                            ascending:YES];
    NSArray *descriptors;
    
    for (SAStudent *student in studentsArray) {
        
        SASection *section = nil;
        NSString *sectionName = nil;
        NSRange range = [[student.fullName lowercaseString] rangeOfString: [filterString lowercaseString]];
        
        if (self.filterControl.selectedSegmentIndex == SAFilterBirthday) {
            NSArray *dateArray = [student.birthDayString componentsSeparatedByString:@"/"];
            sectionName = [dateArray objectAtIndex:1];
            descriptors = [NSArray arrayWithObjects:firstNameDescriptor,
                           lastNameDescriptor,
                           nil];
        } else if (self.filterControl.selectedSegmentIndex == SAFilterFirstName) {
            sectionName = [student.firstName substringToIndex:1];
            descriptors = [NSArray arrayWithObjects:firstNameDescriptor,
                           lastNameDescriptor,
                           birthDayDescriptor,
                           nil];
        } else {
            sectionName = [student.lastName substringToIndex:1];
            descriptors = [NSArray arrayWithObjects:
                           lastNameDescriptor,
                           firstNameDescriptor,
                           birthDayDescriptor,
                           nil];
        }
        
        if ([filterString length] > 0 && range.location == NSNotFound) {
            continue;
        }
        
        NSInteger index = [self getIndexForName:sectionName inSectionsArray:sectionsArray];
        
        if (index >= 0) {
            section = sectionsArray[index];
        } else {
            section = [[SASection alloc] init];
            section.sectionName = sectionName;
            section.itemsArray = [NSMutableArray array];
            [sectionsArray addObject:section];
        }
        
        [section.itemsArray addObject:student];
        
    }
    
    [sectionsArray sortUsingDescriptors:@[sectionNameDescriptor]];
    
    for (SASection *section in sectionsArray) {
        [section.itemsArray sortUsingDescriptors:descriptors];
    }
    
    return sectionsArray;
}

- (NSInteger)getIndexForName:(NSString *)name inSectionsArray:(NSMutableArray *)sectionsArray{
    
    NSInteger index = -1;
    
    for (int i = 0; i < [sectionsArray count]; i++) {
        if ([[sectionsArray[i] sectionName] isEqualToString:name]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    NSMutableArray *array = [NSMutableArray array];

    for (SASection *section in self.sectionsArray) {
        [array addObject:section.sectionName];
    }

    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionsArray objectAtIndex:section] sectionName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SASection *sec = [self.sectionsArray objectAtIndex:section];
    
    return [sec.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    SASection *section = [self.sectionsArray objectAtIndex:indexPath.section];
    
    SAStudent *student = [section.itemsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = student.fullName;
    cell.detailTextLabel.text = student.birthDayString;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
//    NSLog(@"textDidChange %@", searchText);
    
    [self generateSectionsInBackgroundFromArray:self.studentsArray withFilter:self.searchBar.text];
    
}

- (IBAction)actionFilter:(UISegmentedControl *)sender {
    [self generateSectionsInBackgroundFromArray:self.studentsArray withFilter:self.searchBar.text];
}
@end
