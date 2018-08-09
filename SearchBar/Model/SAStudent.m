//
//  SAStudent.m
//  SearchBar
//
//  Created by SA on 8/3/18.
//  Copyright © 2018 SA. All rights reserved.
//

#import "SAStudent.h"

@implementation SAStudent

static NSString *firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString *lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static int namesCount = 50;

static int daysMin = 18 * 365;
static int daysInterval = 5 * 365;

+ (NSDate *)randomDate {
    CGFloat ti = (daysMin + arc4random() % daysInterval) * 24 * 3600.f;
    
    return [NSDate dateWithTimeIntervalSinceNow:-ti];
}

+ (SAStudent *)randomStudent {
    
    SAStudent *student = [[SAStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    student.birthDay = [SAStudent randomDate];
    student.fullName = [SAStudent getFullNameOfStudent:student];
    student.birthDayString = [SAStudent getBirthDayOfStudent:student];
    
    return student;
}

+ (NSString *)getFullNameOfStudent:(SAStudent *)student {
    return [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
}

+ (NSString *)getBirthDayOfStudent:(SAStudent *)student {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    return [dateFormatter stringFromDate:student.birthDay];
}

@end
