//
//  SearchHTTPClient.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "SearchHTTPClient.h"

static NSString * const GithubSearchURLString = @"https://api.github.com/search/";

@implementation SearchHTTPClient

// Uses Grand Central Dispatch to ensure the shared singleton object is only allocated once
+ (SearchHTTPClient *)sharedSearchHTTPClient {
    static SearchHTTPClient *_sharedSearchHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSearchHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:GithubSearchURLString]];
    });
    
    return _sharedSearchHTTPClient;
}

// init object w/ base URL and set it up to request and expect JSON responses from web service
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)searchReposWithName:(NSString *)repoName withLanguage:(NSString *)language
{
    // TODO: change to NSDictionary
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([language length] > 0) {
        parameters[@"q"] = repoName;
    } else {
        parameters[@"q"] = [NSString stringWithFormat:@"%@+language:%@", repoName, language];
    }
    
    [self GET:@"repositories" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(searchHTTPClient:gotResults:)]) {
            [self.delegate searchHTTPClient:self gotResults:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(searchHTTPClient:failedResults:)]) {
            [self.delegate searchHTTPClient:self failedResults:error];
        }
    }];
}

- (void)searchReposWithName:(NSString *)repoName
{
    [self searchReposWithName:repoName withLanguage:@""];
}

@end
