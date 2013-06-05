//
//  MenuVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MenuUndefined = -1,
    MenuScan,
    MenuContacts,
    MenuShare,
    MenuContactUs,
    MenuAbout,
    MenuLogout
} Menu;

@class MenuVC;
@protocol MenuVCDelegate <NSObject>

-(void)menuVC:(MenuVC *)vc didSelectMenu:(Menu)menu;

@end

@interface MenuVC : UITableViewController
{
    NSArray *MenuTitleList;
    NSArray *MenuIconList;
}

@property Menu selectedMenu;
@property (weak, nonatomic) id<MenuVCDelegate>delegate;

@end
