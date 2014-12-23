//
//  SearchHTTPClient.h
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol SearchHTTPClientDelegate;

@interface SearchHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<SearchHTTPClientDelegate>delegate;

+ (SearchHTTPClient *)sharedSearchHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
// TODO: add method that takes in parameters
- (void)searchReposWithName:(NSString *)repoName;
- (void)searchReposWithName:(NSString *)repoName withLanguage:(NSString *)language;


@end

// Delegate to handle successful and failed responses on Github Search
@protocol SearchHTTPClientDelegate <NSObject>
@optional
-(void)searchHTTPClient:(SearchHTTPClient *)client gotResults:(id)results;
-(void)searchHTTPClient:(SearchHTTPClient *)client failedResults:(NSError *)error;

@end
