//
//  NSMutableArray+Functions.m
//  MostPopularFour
//
//  Created by Alexander Krupnik on 10/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import "NSMutableArray+Functions.h"

@implementation NSMutableArray (Functions)

- (id)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return self;
}
@end
