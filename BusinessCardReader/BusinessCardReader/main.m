//
//  main.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface MyApplication : UIApplication {
    
}

@end

@implementation MyApplication


-(BOOL)openURL:(NSURL *)url{
    if  ([self.delegate performSelector:@selector(openURL:) withObject:url])
        return YES;
    else
        return [super openURL:url];
}
@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, @"MyApplication", NSStringFromClass([AppDelegate class]));
    }
}
