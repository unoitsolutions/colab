//
//  LinkedInComposeViewControllerConfig.h
//  LinkedInComposeViewController
//
//  Created by Patricia Marie Cesar on 5/23/13.
//  Copyright (c) 2013 Patricia Marie Cesar. All rights reserved.
//


#ifndef LinkedInComposeViewController_Config_h
#define LinkedInComposeViewController_Config_h


// API KEYS

#define LINKEDIN_API_KEY @"hx7mnjl28l9w"
#define LINKEDIN_SECRET_KEY @"p2E6ckMVdxjHDi3m"
#define LINKEDIN_POST_URL [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"]

// Strings

#define LINKEDIN_POST_MESSAGE_SUCCESS @"Successfully updated status."
#define LINKEDIN_POST_MESSAGE_FAIL @"There was an error posting your status."
// UI

#define LINKEDIN_SHEET_TEXT_PLACEHOLDER @"Placeholder text"
#define LINKEDIN_SHEET_TEXT_INITIAL @"Initial text"
#define LINKEDIN_SHEET_LOGO_FRAME CGRectMake(0, 0, 100, 25)
#define LINKEDIN_SHEET_LOGO [UIImage imageNamed:@"linkedIn_logo"]
#define LINKEDIN_SHEET_BG [UIImage imageNamed:@"linkedIn_bg"]
#define LINKEDIN_SHEET_BUTTON_COLOR_LEFT [UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1]
#define LINKEDIN_SHEET_BUTTON_COLOR_RIGHT [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1]



#endif









