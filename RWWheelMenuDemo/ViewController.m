//
//  ViewController.m
//  RWWheelMenuDemo
//
//  Created by William REN on 9/28/14.
//
//

#import "ViewController.h"
#import "RWWheelMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RWWheelMenu *menu = [[RWWheelMenu alloc] initWithFrame:CGRectMake(25, 200, 270, 270)
                                                    titles:@[@"Item00",
                                                             @"Item01",
                                                             @"Item02",
                                                             @"Item03",
                                                             @"Item04"]
                                              buttonImages:@[@"menu_button_00.png",
                                                             @"menu_button_01.png",
                                                             @"menu_button_02.png",
                                                             @"menu_button_03.png",
                                                             @"menu_button_04.png"]
                                           backgroundImage:@"menu_background.png"
                                        menuItemClickBlock:^(int tag) {
                                            NSLog(@"Menu Item %02d clicked!", tag);
                                        }];
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
