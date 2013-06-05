//
//  LoginVC.h
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCRAccountManager.h"

@class LoginVC;
@protocol LoginVCDelegate <NSObject>

- (void)loginVC:(LoginVC *)vc didLoginWithInfo:(NSDictionary *)info;

@end

@interface LoginVC : UIViewController <UITextFieldDelegate, APIManagerDelegate, BCRAccountManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *keepMeLoggedInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *forgotPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *fpEmailAddressField;
@property (weak, nonatomic) IBOutlet UIButton *fpCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *fpSendButton;
@property (nonatomic) BOOL isPersistentLogin;
@property (weak, nonatomic) id<LoginVCDelegate> delegate;

- (IBAction)keepMeLoggedInTapped:(id)sender;
- (IBAction)forgotPasswordTapped:(id)sender;
- (IBAction)loginTapped:(id)sender;
- (IBAction)cancelForgotPasswordTapped:(id)sender;
- (IBAction)sendForgotPasswordTapped:(id)sender;

@end
