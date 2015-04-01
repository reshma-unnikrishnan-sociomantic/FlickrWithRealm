//
//  ViewController.m
//  pinterestWithRealm
//
//  Created by Reshma on 31/03/15.
//  Copyright (c) 2015 ruvlmoon. All rights reserved.
//

#import "ViewController.h"
#import <Realm/Realm.h>
#import "ObjectiveFlickr.h"
#import "User.h"
#import "photoDetails.h"


NSString *const FlickrAPIKey = @"16f8eadd7ff42c8f0bf35a25473c7457";
NSString *const FlickrAPISecret = @"7c2f6ffc99acfffe";

@interface ViewController () <OFFlickrAPIRequestDelegate , NSURLSessionDownloadDelegate>
@property (nonatomic) OFFlickrAPIContext *flickrContext;
@property (nonatomic) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic) NSURLSession  *urlSession;
@property (nonatomic) NSURLRequest *urlRequest;
@property (nonatomic) NSURLSessionDownloadTask *sessionDownTask;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:FlickrAPIKey sharedSecret:FlickrAPISecret];
    self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [self makeNextPhotoRequest];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)makeNextPhotoRequest
{
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
    self.flickrRequest.delegate = self;
    [self.flickrRequest callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:@{@"per_page": @"100"}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FlickerAPICallBacks
-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary {
    RLMRealm *realm ;
    realm = [RLMRealm defaultRealm];
//adding write transactions
    [realm beginWriteTransaction];


    for (int i = 0; i <= 99;  i++) {
        NSMutableDictionary *ophotoStream = (NSMutableDictionary *)[[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:i];
        NSString *title = ophotoStream[@"title"];
        if (![title length]) {
            title = @"no title provided";
        }
        self.flickrRequest = nil;
        NSURL *photoUrl = [self.flickrContext photoWebPageURLFromDictionary:ophotoStream];
        self.sessionDownTask = [self.urlSession downloadTaskWithURL:photoUrl
                                                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                      UIImageView *imgVw = [[UIImageView alloc] initWithImage:image];
                                                  }];
        NSLog(@"%@ :: (%@)", photoUrl , self.sessionDownTask);
        NSLog(@"%@" ,[RLMRealm defaultRealmPath]);
        [self.sessionDownTask resume];



        User *userGuy = [[User alloc] init];
        userGuy.UserId = ophotoStream[@"owner"];

        photoDetails *dtails = [[photoDetails alloc] init];
        dtails.isFamily = ophotoStream[@"isfamily"];
        dtails.title = ophotoStream[@"title"];
        dtails.flickrPicture =[photoUrl absoluteString];
        [userGuy.userPhoto addObject:dtails];
        [realm addObject:dtails];
        [realm addObject:userGuy];

}
    [realm commitWriteTransaction];

}

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError {
    if (inError) {
        NSLog(@"Error downloading the Url");
    }
}


@end
