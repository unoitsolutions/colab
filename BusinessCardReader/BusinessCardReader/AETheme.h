//
//  AETheme.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIGlossyButton.h"

extern NSString *AEThemeChangedNotification;

@interface AETheme : NSObject

+ (AETheme *) sharedInstance;

@property (strong, nonatomic) UIColor *defaultMainColor;
@property (strong, nonatomic) UIColor *defaultDarkMainColor;
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
@property (strong, nonatomic) UIColor *defaultLightGrayColor;
@property (strong, nonatomic) UIColor *defaultGrayColor;
@property (strong, nonatomic) UIColor *defaultDarkGrayColor;
@property (strong, nonatomic) NSString *defaultFontFamily;

- (void)restoreToDefaultSetting;

// buttons
- (void) applyDefaultThemeToGlossyButton:(UIGlossyButton *)button;

@end
