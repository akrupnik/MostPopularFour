//
//  ShowFour.h
//  MostPopularFour
//
//  Created by Alexander Krupnik on 07/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourImages.h"
#import "NSMutableArray+Functions.h"

@interface ShowFour : UIViewController {
    BOOL _imagesShown;
}
@property(nonatomic,strong) NSMutableArray *imgIds;

@property (weak, nonatomic) IBOutlet FourImages *fourImagesView;
- (IBAction)refresh:(id)sender;
-(void) showFourPicturesWithIndex:(int) index andData: (NSData *) data;
-(void) clearFourImages;
+ (NSURLSession *)session;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
