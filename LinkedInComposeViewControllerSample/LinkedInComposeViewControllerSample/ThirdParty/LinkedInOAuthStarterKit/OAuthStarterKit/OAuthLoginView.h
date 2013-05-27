//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

/* Added by Patricia Cesar: May 23, 2013 */

typedef NS_ENUM(NSInteger, OAuthLoginResult) {
    OAuthLoginResultFail,
    OAuthLoginResultSuccess
};

typedef NS_ENUM(NSInteger, OAuthPostResult) {
    OAuthPostResultFail,
    OAuthPostResultSuccess
};

typedef void (^OAuthLoginViewCompletionHandler)(OAuthLoginResult result, OAToken *token, OAConsumer *consumer);
typedef void (^OAuthPostCompletionHandler)(OAuthPostResult result, NSData *data);

/* end */

@interface OAuthLoginView : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *addressBar;
    
    OAToken *requestToken;
    OAToken *accessToken;
    OAConsumer *consumer;
    
    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
}

@property(nonatomic, retain) OAToken *requestToken;
@property(nonatomic, retain) OAToken *accessToken;
@property(nonatomic, retain) NSDictionary *profile;
@property(nonatomic, retain) OAConsumer *consumer;

/* Added by Patricia Cesar: May 23, 2013 */
@property(nonatomic, copy, readwrite) OAuthLoginViewCompletionHandler loginCompletionHandler;
@property(nonatomic, copy, readwrite) OAuthPostCompletionHandler postCompletionHandler;
/* end */

- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;

@end
