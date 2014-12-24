//
//  RepoTableViewCell.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "RepoTableViewCell.h"

@implementation RepoTableViewCell

// Put Label for name of Repo
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.repoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, 200.0f, self.contentView.bounds.size.height)];
        [self.repoLabel setTextColor:[UIColor blueColor]];
        
        [self.contentView addSubview:self.repoLabel];
    }
    
    return self;
}

@end
