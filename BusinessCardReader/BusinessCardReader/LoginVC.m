//
//  LoginVC.m
//  BusinessCardReader
//
//  Created by Pinuno Fuentes on 3/18/13.
//  Copyright (c) 2013 Pinuno Fuentes. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

- (BOOL)_isFormValid;
- (void)_dismissKeyboard;

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // login view
    self.view.backgroundColor = [[BCRAccountManager defaultManager] defaultBGColor];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.loginButton];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(_dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    // forgot password view
//    self.forgotPasswordView.backgroundColor = [[AETheme sharedInstance] defaultBackgroundColor];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.fpCancelButton];
//    [[AETheme sharedInstance] applyDefaultThemeToGlossyButton:self.fpSendButton];
    
    // login notification
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(AESessionManagerNotificationLoginFinishedHandler:)
//                                                 name:AESessionManagerNotificationLoginFinished
//                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setForgotPasswordView:nil];
    [self setFpEmailAddressField:nil];
    [self setFpCancelButton:nil];
    [self setFpSendButton:nil];
    [self setKeepMeLoggedInButton:nil];
    [self setForgotPasswordButton:nil];
    [super viewDidUnload];
}

#pragma mark - Action Methods

- (IBAction)keepMeLoggedInTapped:(UIButton *)sender
{
    self.isPersistentLogin = !self.isPersistentLogin;
    if (self.isPersistentLogin) {
        [sender setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    }
}

- (IBAction)forgotPasswordTapped:(id)sender
{
    CGRect frame = self.forgotPasswordView.frame;
    frame.origin.x = 0;
    frame.origin.y = 142;
    self.forgotPasswordView.frame = frame;
    
    self.emailAddressField.hidden = YES;
    self.passwordField.hidden = YES;
    self.keepMeLoggedInButton.hidden = YES;
    self.forgotPasswordButton.hidden = YES;
    self.loginButton.hidden = YES;
    
    [self.view addSubview:self.forgotPasswordView];
}

- (IBAction)loginTapped:(id)sender
{
    // form validation
    if(![self _isFormValid]) return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // login
    DLOG(@"isPersistentLogin: %i",self.isPersistentLogin);
    NSDictionary *info = @{@"isPersistent":[NSNumber numberWithBool:self.isPersistentLogin],
                           @"username":self.emailAddressField.text,
                           @"password":self.passwordField.text};
    [[BCRAccountManager defaultManager] setDelegate:self];
    [[BCRAccountManager defaultManager] loginWithInfo:info];
}

- (IBAction)cancelForgotPasswordTapped:(id)sender
{
    DLOG(@"");
    
    self.emailAddressField.hidden = NO;
    self.passwordField.hidden = NO;
    self.keepMeLoggedInButton.hidden = NO;
    self.forgotPasswordButton.hidden = NO;
    self.loginButton.hidden = NO;
    
    self.fpEmailAddressField.text = @"";
    [self.fpEmailAddressField resignFirstResponder];
    [self.forgotPasswordView removeFromSuperview];
    
    [self _dismissKeyboard];
}

- (IBAction)sendForgotPasswordTapped:(id)sender
{
    DLOG(@"");
    
    // email validation
    NSString *emailAddress = self.fpEmailAddressField.text;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(emailAddress.length <= 0 || ![emailTest evaluateWithObject:emailAddress]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid email address. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // initiate retrieve password
    APIManager *manager = [[APIManager alloc] init];
    manager.delegate = self;
    [manager doInitRetrievePassword:@{@"emailaddress":emailAddress}];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.emailAddressField){
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }else{
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

#pragma mark - BCRAccountManagerDelegate Methods

- (void)manager:(BCRAccountManager *)manager didLoginWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    DLOG(@"info: %@",info);
    
    // update UI
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.emailAddressField.text = @"";
    self.passwordField.text = @"";
    
    // show alert if there is an error
    NSError *error = [info objectForKey:@"error"];
    if (error) {

//#warning comment debug code
        // debug
//        if ([self.delegate respondsToSelector:@selector(loginVC:didLoginWithInfo:)]) {
//            [self.delegate loginVC:self didLoginWithInfo:@{}];
//        }
//        return;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Login failed. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    // else update delegate
    else{
        if ([self.delegate respondsToSelector:@selector(loginVC:didLoginWithInfo:)]) {
            [self.delegate loginVC:self didLoginWithInfo:@{}];
        }
    }
}

#pragma mark - APIManagerDelegate Methods

- (void)APIManager:(APIManager *)manager didInitRetrievePasswordWithInfo:(NSDictionary *)info
{
    manager.delegate = nil;
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if ([info objectForKey:@"error"]) {
        DLOG(@"error: %@",[(NSError *)[info objectForKey:@"error"] localizedDescription]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:(((NSString *)[info objectForKey:@"reason"]).length > 0 ? @"No account found with that email address" : @"Unable to send email address to server. Please try again.")
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Email address sent to server. Please check your mail for further instructions."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.emailAddressField.hidden = NO;
    self.passwordField.hidden = NO;
    self.keepMeLoggedInButton.hidden = NO;
    self.forgotPasswordButton.hidden = NO;
    self.loginButton.hidden = NO;
    
    self.fpEmailAddressField.text = @"";
    [self.fpEmailAddressField resignFirstResponder];
    [self.forgotPasswordView removeFromSuperview];
    
    [self _dismissKeyboard];
}

#pragma mark - Convenience Methods

- (BOOL)_isFormValid
{
#ifdef MDEBUG
    if ([self.emailAddressField.text isEqualToString:@"demo"] && [self.passwordField.text isEqualToString:@"demo"] ) {
        return YES;
    }
#endif
    
    // email validation
//    NSString *emailAddrress = self.emailAddressField.text;
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    if(emailAddrress.length <= 0 || ![emailTest evaluateWithObject:emailAddrress]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"Invalid email address. Please try again."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//        return NO;
//    }
    
    // password validation
    NSString *password = self.passwordField.text;
    if(password <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid password. Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)_dismissKeyboard
{
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.fpEmailAddressField resignFirstResponder];
}

@end
