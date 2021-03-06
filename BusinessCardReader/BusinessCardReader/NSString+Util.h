//
//  NSString+Util.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 4/11/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

- (BOOL)isNull;
- (NSString*)stringByTrimmingLeadingWhitespace;
- (BOOL)containsStringNoCase:(NSString *)searchString;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

+ (NSString *)stringWithData:(NSData *)data;

@end
