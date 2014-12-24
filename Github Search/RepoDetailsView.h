//
//  RepoDetailsView.h
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoDetailsView : UIScrollView

@property (nonatomic, strong) UIImageView *ownerImageView;
@property (nonatomic, strong) UILabel *ownerLabel;
@property (nonatomic, strong) UILabel *htmlURL;
@property (nonatomic, strong) NSNumber *numOfStars;
@property (nonatomic, strong) UILabel *canForkLabel;

- (void)initOwnerImageViewWithImage:(UIImage *)ownerImage;

@end
