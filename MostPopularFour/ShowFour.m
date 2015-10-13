//
//  showFour.m
//  MostPopularFour
//
//  Created by Alexander Krupnik on 07/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import "ShowFour.h"

@interface ShowFour () {
}
@end

@implementation ShowFour

- (void)viewDidLoad {
    NSLog(@"show four");
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
}

+ (NSURLSession *)session {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [configuration setHTTPMaximumConnectionsPerHost:1];
        
        session = [NSURLSession sessionWithConfiguration:configuration];
        
    });
    return session;
}

-(void) showFourPicturesWithIndex:(int) index andData: (NSData *) data {
    
    //[self.activityIndicator stopAnimating];
    NSLog(@"index=%ul",index);
    
    
    if(index == 0) {
        self.fourImagesView.imageView1.image = [UIImage imageWithData:data];
    }
    else if (index == 1) {
        self.fourImagesView.imageView2.image = [UIImage imageWithData:data];
    }
    else if (index == 2) {
        self.fourImagesView.imageView3.image = [UIImage imageWithData:data];
    }
    else {
        self.fourImagesView.imageView4.image = [UIImage imageWithData:data];
        self.imgIds = nil;
        _imagesShown = true;
        [self.activityIndicator stopAnimating];
    }
    
}

-(void) clearFourImages {
    self.fourImagesView.imageView1.image = nil;
    self.fourImagesView.imageView2.image = nil;
    self.fourImagesView.imageView3.image = nil;
    self.fourImagesView.imageView4.image = nil;
}


- (IBAction)refresh:(id)sender {
   //implement in a subclass
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
