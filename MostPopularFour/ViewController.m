//
//  ViewController.m
//  MostPopularFour
//
//  Created by Alexander Krupnik on 06/10/15.
//  Copyright (c) 2015 Alexander Krupnik. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goFacebook"]) {
       
        [segue destinationViewController];
    }
    else if ([segue.identifier isEqualToString:@"goInstagram"]) {
        
        [segue destinationViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
