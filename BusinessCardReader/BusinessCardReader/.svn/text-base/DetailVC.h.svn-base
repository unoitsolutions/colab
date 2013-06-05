//
//  DetailVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailVC <NSObject>

@optional
- (UIView *)navigationBar;
- (UIButton *)menuButton;
- (UIButton *)cameraButton;

@end

@class DetailVC;
@protocol DetailVCDelegate <NSObject>

@optional
- (void)detailVC:(DetailVC *)vc menuBarButtonTapped:(id)sender;
- (void)detailVC:(DetailVC *)vc cameraButtonTapped:(id)sender;
- (void)detailVC:(DetailVC *)vc logoutButtonTapped:(id)sender;
- (void)detailVC:(DetailVC *)vc createContactButtonTapped:(id)sender;

@end

@interface DetailVC : UIViewController <DetailVC>

@property (strong, nonatomic) UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) id<DetailVCDelegate> delegate;

- (void)slideRight;
- (void)slideLeft;

//- (void)AEThemeChangedNotificationHandler:(NSNotification *)note;

@end
