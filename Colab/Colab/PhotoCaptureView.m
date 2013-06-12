//
//  PhotoCaptureView.m
//  Colab
//
//  Created by Christine Ramos on 6/8/13.
//  Copyright (c) 2013 UNO IT Solutions, LLC. All rights reserved.
//

#import "PhotoCaptureView.h"

@interface PhotoCaptureView ()

@property (nonatomic, strong) UIImageView *camera;
@property (nonatomic, strong) UIImageView *closeButton;

@end

@implementation PhotoCaptureView

@synthesize camera = _camera;
@synthesize closeButton = _closeButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
