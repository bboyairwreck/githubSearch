//
//  RepoDetailsView.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "RepoDetailsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RepoDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect ownerLabelRect = CGRectMake(0.0f, self.center.y + 31.0f, 200.0f, 31.0f);
        UILabel *ownerLabel = [[UILabel alloc] initWithFrame:ownerLabelRect];
        self.backgroundColor = [UIColor whiteColor];
        
        ownerLabel.textAlignment = NSTextAlignmentCenter;
        
        self.ownerLabel = ownerLabel;
        
        [self addSubview:self.ownerLabel];
        
        [self addConstraint:[self centerXView:self.ownerLabel withAncestor:self]];
    }
    
    return self;
}

- (NSLayoutConstraint *)centerXView:(UIView *)view withAncestor:(UIView *)ancestor
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:ancestor
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0f
                                                                          constant:0.0f];
    return centerXConstraint;
}

- (NSLayoutConstraint *)bottomAlignYView:(UIView *)view withSibling:(UIView *)sibling
{
    NSLayoutConstraint *bottomAlginConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:sibling
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:30.0f];
    return bottomAlginConstraint;
}



- (void)initOwnerImageViewWithImage:(UIImage *)ownerImage
{
    CGFloat halfScreen = self.bounds.size.width / 2.0f;
    CGRect tempRect = CGRectMake(halfScreen / 2.0f,
                                 20.0f,
                                 halfScreen,
                                 halfScreen);
    UIImageView *ownerImageView = [[UIImageView alloc] initWithFrame:tempRect];
    
    ownerImageView.image = ownerImage;
    
    ownerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    ownerImageView.clipsToBounds = YES;
    ownerImageView.layer.cornerRadius = ownerImageView.frame.size.width / 2.0f;
    
    
    self.ownerImageView = ownerImageView;
    
    
    [self addSubview:self.ownerImageView];
    
    [self addConstraint:[self bottomAlignYView:self.ownerLabel withSibling:self.ownerImageView]];
    
}



@end
