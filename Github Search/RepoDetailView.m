//
//  RepoDetailsView.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "RepoDetailView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RepoDetailView

// Add all labels
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGRect ownerLabelRect = CGRectMake(0.0f, self.center.y + 31.0f, 200.0f, 31.0f);
        UILabel *ownerLabel = [[UILabel alloc] initWithFrame:ownerLabelRect];
        self.backgroundColor = [UIColor whiteColor];
        ownerLabel.textAlignment = NSTextAlignmentCenter;
        
        self.ownerLabel = [self createLabel];
        self.numOfStars = [self createLabel];
        self.repoURL = [self createLabel];
        self.canForkLabel = [self createLabel];
        
        self.repoURL.textColor = [UIColor blueColor];
        
        [self addSubview:self.ownerLabel];
        [self addSubview:self.repoURL];
        [self addSubview:self.numOfStars];
        [self addSubview:self.canForkLabel];
        
        NSArray *centerContraints = [[NSArray alloc] initWithObjects:
                                     [self centerXView:self.ownerLabel withAncestor:self],
                                     [self centerXView:self.repoURL withAncestor:self],
                                     [self centerXView:self.numOfStars withAncestor:self],
                                     [self centerXView:self.canForkLabel withAncestor:self],
                                     nil];
        
        [self addConstraints:centerContraints];
        
    }
    
    return self;
}

// Create Labels for
- (UILabel *)createLabel
{
//    CGRect labelRect = CGRectMake(0.0f, 0.0f, self.frame.size.width, 70.0f);
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return label;
}

// Add constraint for horizontally centering
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

// Add constraight for bottom alignment
- (NSLayoutConstraint *)bottomAlignYView:(UIView *)view withSibling:(UIView *)sibling
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottomAlginConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:sibling
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0f
                                                                              constant:30.0f];
    return bottomAlginConstraint;
}

// Add left constraint for padding
- (NSLayoutConstraint *)paddingWithView:(UIView *)view withAncestor:(UIView *)ancestor
{

    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:ancestor
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0f
                                                                       constant:10.0f];

    
    return leftConstraint;
}

// Add image to the DetailsView
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
    
    [self addLabelConstraints];
}

// Add autolayout constraights to all UILaesl
- (void)addLabelConstraints {
    NSArray *constraints = [[NSArray alloc] initWithObjects:
                            [self bottomAlignYView:self.ownerLabel withSibling:self.ownerImageView],
                            [self bottomAlignYView:self.repoURL withSibling:self.ownerLabel],
                            [self bottomAlignYView:self.numOfStars withSibling:self.repoURL],
                            [self bottomAlignYView:self.canForkLabel withSibling:self.numOfStars],
                            [self paddingWithView:self.repoURL withAncestor:self],
                            nil];
    
    [self addConstraints:constraints];
}


@end
