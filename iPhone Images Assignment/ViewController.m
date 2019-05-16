//
//  ViewController.m
//  iPhone Images Assignment
//
//  Created by Luiz on 5/16/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
 [super viewDidLoad];

}
- (IBAction)changeImage:(id)sender {

    // Do any additional setup after loading the view, typically from a nib.

    NSURL *url = [NSURL URLWithString: [self geRandomtURL]]; // 1

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3

    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }

        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data]; // 2

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            self.image.image = image; //


        }];


    }];

    [task resume]; // 5
}

-(NSString*) geRandomtURL {
    switch ([self randomNumberBetween:0 andMax:4 ] ){
        case 0:
            return @"http://imgur.com/bktnImE.png";
            break;
        case 1:
            return @"http://imgur.com/zdwdenZ.png";
            break;
        case 2:
            return @"http://imgur.com/CoQ8aNl.png";
            break;
        case 3:
            return @"http://imgur.com/2vQtZBb.png";
            break;
        default :
            return @"http://imgur.com/y9MIaCS.png";
            break;
    }
}


-(NSInteger)randomNumberBetween: (NSInteger) min andMax:(NSInteger) max {
    return  (min + arc4random_uniform((uint32_t)(max - min + 1)));


}

@end
