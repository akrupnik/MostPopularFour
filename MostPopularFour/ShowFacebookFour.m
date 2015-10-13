//
//  ShowFacebookFour.m
//  MostPopularFour
//
//  Created by Alexander Krupnik on 11/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import "ShowFacebookFour.h"

@interface ShowFacebookFour () {
    
}
@property(nonatomic,strong) NSArray *albumIds;
@end

static NSString *const FACEBOOK_ACCESS_TOKEN = @"CAAXuWOPMyrcBAKd0LoNzPtcVYo737s4enUO1r8OMy2FPEb8zv88liGxWb5K5wwSOdiIPcV5kLAqWh9O8JVyUFBAd9JG85620JCMF2RI9SLaDp7HNO3Ks1gZBIPyVnmBANJywJWUJ90IZBPyZBC39ioBg7UZASDisG5TFT3wvuaaEK0fYIp7Qc1Bo9cHJI1kZD";

@implementation ShowFacebookFour

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Facebook random four";
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    self.fourImagesView.imageView1.image = nil;
    self.fourImagesView.imageView2.image = nil;
    self.fourImagesView.imageView3.image = nil;
    self.fourImagesView.imageView4.image = nil;
    
    /*
    for (UIView *view in [self.fourImagesView subviews]) {
        if([view isKindOfClass:[UIImageView class]] ) {
           [view removeFromSuperview];
        }
    }
     */
    [self prepareForFacebook];
}


- (void) prepareForFacebook {
    self.imgIds = [[NSMutableArray alloc] init];
    _imagesShown = false;
    [self retrieveFourPictures];
}


-(void) retrieveFourPictures {
    
    // get album list
    [self.activityIndicator startAnimating];
    NSString *albumListQuery = [NSString stringWithFormat:@"https://graph.facebook.com/v2.1/116856095313846/albums?access_token=%@",FACEBOOK_ACCESS_TOKEN];
    NSURLSessionDataTask *dataTask = [ [[self class] session] dataTaskWithURL:[NSURL URLWithString:albumListQuery] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if(jsonError) {
            NSLog(@"JSON serialisation error = %@", error);
            return;
        }
        
        NSArray *items = [json objectForKey:@"data"];
        NSMutableArray *albumIds = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [items count]; i++) {
            [albumIds addObject:[items[i] objectForKey:@"id"]];
        }
        self.albumIds = [albumIds shuffle];
        //get image IDs
        NSOperationQueue  *imageQueue = [NSOperationQueue new];
        [imageQueue addOperationWithBlock:^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            __block BOOL foundFour = false;
            for(int i=0; !foundFour && i < [self.albumIds count]; i++) {
                NSLog(@"imgIDs, i= %ul foundFour=%i", i,foundFour);
                NSString *query = [NSString stringWithFormat:@"https://graph.facebook.com/v2.1/%@/photos?access_token=%@",self.albumIds[i],FACEBOOK_ACCESS_TOKEN];
                NSURLSessionDataTask *imageIDdataTask = [[[self class] session] dataTaskWithURL:[NSURL URLWithString:query] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (error) {
                       NSLog(@"error=%@",error);
                    }
                    NSError *jsonImgErr;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonImgErr];
                    if(jsonImgErr) {
                        NSLog(@"JSON img error = %@", error);
                        return;
                    }
                    
                    NSArray *albumItems = [json objectForKey:@"data"];
                    if([albumItems count] != 0) {
                        NSMutableArray *albumItemsMutable = [albumItems mutableCopy];
                        [albumItemsMutable shuffle];
                        [self.imgIds addObject:[albumItemsMutable[0] objectForKey:@"id"]];
                    }
                    if ([self.imgIds count] == 4) {
                        NSLog(@"show pictures");
                        foundFour = true;
                        [self showFourFacebookPictures];
                    }
                    dispatch_semaphore_signal(semaphore);
                    
                }];
                [imageIDdataTask resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }];
    }];
    [dataTask resume];
}


-(void) showFourFacebookPictures {
    
    for(int i = 0; i < 4; i++) {
        
        NSString *query = [NSString stringWithFormat:@"https://graph.facebook.com/v2.1/%@/picture?access_token=%@",self.imgIds[i],FACEBOOK_ACCESS_TOKEN];
        NSURLSessionDataTask *imagedataTask = [[[self class] session] dataTaskWithURL:[NSURL URLWithString:query] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFourPicturesWithIndex:i andData:data];
            });
        }];
        [imagedataTask resume];
    }
}


- (IBAction)refresh:(id)sender {
    
    if(_imagesShown) {
       [self clearFourImages];
        _imagesShown = false;
       [self prepareForFacebook];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
