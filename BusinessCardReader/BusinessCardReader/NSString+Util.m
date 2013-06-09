//
//  NSString+Util.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/11/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (BOOL)isNull
{
    if (self.length <= 0) return YES;
    if ([self isEqual:@"<null>"]) return YES;
    if ([self isEqual:@"null"]) return YES;
    
    return NO;
}

- (NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

- (BOOL)containsStringNoCase:(NSString *)searchString
{
    return ([self rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) ? YES : NO;
}

+ (NSString *)stringWithData:(NSData *)data
{
   return [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
}


@end
