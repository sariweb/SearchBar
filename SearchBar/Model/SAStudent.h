//
//  SAStudent.h
//  SearchBar
//
//  Created by SA on 8/3/18.
//  Copyright © 2018 SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SAStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSDate *birthDay;
@property (strong, nonatomic) NSString *birthDayString;

+ (SAStudent*)randomStudent;
+ (NSDate *)randomDate;

+ (NSString *)getFullNameOfStudent:(SAStudent *)student;
+ (NSString *)getBirthDayOfStudent:(SAStudent *)student;

@end
