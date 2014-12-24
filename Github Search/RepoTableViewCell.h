//
//  RepoTableViewCell.h
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *repoData;
@property (nonatomic, strong) UILabel *repoLabel;

@end
