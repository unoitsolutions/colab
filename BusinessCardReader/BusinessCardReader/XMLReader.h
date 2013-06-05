//
//  XMLReader.h
//  BusinessCardReader
//
//  Source: http://ios.biomsoft.com/2011/09/11/simple-xml-to-nsdictionary-converter/
//
//  Created by Pinuno Fuentes on 3/22/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *dictionaryStack;
@property (strong, nonatomic) NSMutableString *textInProgress;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
