//
//  AETheme.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/24/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "AETheme.h"

NSString *AEThemeChangedNotification = @"AEThemeChangedNotification";

@implementation AETheme

- (id)init
{
    self = [super init];
    if (self) {
        [self restoreToDefaultSetting];
    }
    return self;
}

+ (AETheme *) sharedInstance
{
    static AETheme *_sharedInstance;
    if(!_sharedInstance){
        _sharedInstance = [[AETheme alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - Methods

- (void)restoreToDefaultSetting
{
    self.defaultMainColor = [UIColor colorWithRed:(48.0/256.0) green:(100.0/256) blue:(136.0/256.0) alpha:1];
    self.defaultDarkMainColor = [UIColor colorWithRed:(28.0/256.0) green:(80.0/256) blue:(116.0/256.0) alpha:1];
    self.defaultBackgroundColor = [UIColor colorWithRed:(38.0/256.0) green:(39.0/256) blue:(41.0/256.0) alpha:1];
    self.defaultLightGrayColor = [UIColor colorWithRed:(198.0/256.0) green:(198.0/256) blue:(198.0/256.0) alpha:1];
    self.defaultGrayColor = [UIColor colorWithRed:(186.0/256.0) green:(188.0/256) blue:(187.0/256.0) alpha:1];
    self.defaultDarkGrayColor = [UIColor colorWithRed:(148.0/256.0) green:(148.0/256) blue:(148.0/256.0) alpha:1];
    self.defaultFontFamily = [UIFont systemFontOfSize:3].familyName;
}

#pragma mark - Buttons

- (void) applyDefaultThemeToGlossyButton:(UIGlossyButton *)button
{
    button.tintColor = self.defaultMainColor;
    button.borderColor = self.defaultDarkGrayColor;
    [button useWhiteLabel: YES];
    button.buttonCornerRadius = 2.0;
    button.buttonBorderWidth = 2.0f;
    [button setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
}

@end
