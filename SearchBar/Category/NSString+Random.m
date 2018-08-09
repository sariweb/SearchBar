//
//  NSString+Random.m
//  SearchBar
//
//  Created by SA on 8/7/18.
//  Copyright © 2018 SA. All rights reserved.
//

#import "NSString+Random.h"

@implementation NSString (Random)

+ (NSString *)randomAlphanumericString {
    
    int length = arc4random() % 11 + 5;
    
    return [self randomAlphanumericStringWithLength:length];
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz";//ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
