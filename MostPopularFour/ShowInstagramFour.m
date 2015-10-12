//
//  ShowInstagramFour.m
//  MostPopularFour
//
//  Created by Alexander Krupnik on 11/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import "ShowInstagramFour.h"

@interface ShowInstagramFour ()
@property (strong, nonatomic) NSArray *sortedItems;
@end

static NSString *const  INSTAGRAM_QUERY = @"https://api.instagram.com/v1/media/popular?access_token=2218748617.ea3ed6e.b4f54912924d410cbabe0a2a97393a82";


@implementation ShowInstagramFour

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortedItems = nil;
    //self.navigationItem.title = @"Instagram most popular four";
    self.title = @"Instagram most popular four";
    
    
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFourPictures];
}

-(void) loadFourPictures {
    [self.activityIndicator startAnimating];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:INSTAGRAM_QUERY] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        //NSLog(@"%@",json);
        if(jsonError) {
            NSLog(@"JSON serialisation error = %@", error);
            return;
        }
        NSArray *items = [json objectForKey:@"data"];
        NSArray *sortedArray = [items sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            int first = (int) [[a objectForKey:@"likes"] objectForKey:@"count"];
            int second = (int)[[b objectForKey:@"likes"] objectForKey:@"count"];
            return first <= second;
        }];
        self.sortedItems = sortedArray;
        [self displayPictures];
    }];
    [dataTask resume];
}


-(void) displayPictures {
    if(!self.sortedItems) return;
    NSURLSession *imageGetSession = [NSURLSession sharedSession];
    NSLog(@"display pictures");
    for(int i = 0; i < 4; i++) {
        id item = self.sortedItems[i];
        id imgUrl =[[[item objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        NSURL *url = [NSURL URLWithString:imgUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        NSURLSessionDataTask *getDataTask = [imageGetSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFourPicturesWithIndex:i andData:data];
            });
        }];
        [getDataTask resume];
    }//for
}

- (IBAction)refresh:(id)sender {
    [self loadFourPictures];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
