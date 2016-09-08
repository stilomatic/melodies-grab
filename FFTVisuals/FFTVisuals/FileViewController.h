//
//  FileViewController.h
//  FFTVisuals
//
//  Created by AntonioStilo on 28/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileViewController : UIViewController

@property(nonatomic,strong) NSDictionary *metadata;
@property(nonatomic,strong) IBOutlet UITextField *titleText;
@property(nonatomic,strong) IBOutlet UILabel *dateText;

@end
