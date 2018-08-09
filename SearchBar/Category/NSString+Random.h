//
//  NSString+Random.h
//  SearchBar
//
//  Created by SA on 8/7/18.
//  Copyright © 2018 SA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

+ (NSString *)randomAlphanumericString;
+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;

@end
