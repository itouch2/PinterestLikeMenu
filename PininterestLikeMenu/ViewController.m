//
//  ViewController.m
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "ViewController.h"
#import "PininterestLikeMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popPininterestMenu:)];
    [self.view addGestureRecognizer:gesture];
    
}

- (void)popPininterestMenu:(UIGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan)
    {
        return ;
    }
    
    PininterestLikeMenuItem *item0 = [[PininterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                       selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                      selectedBlock:^(void) {
                                                                          NSLog(@"item 0 selected");
                                                                      }];
    PininterestLikeMenuItem *item1 = [[PininterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                       selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                      selectedBlock:^(void) {
                                                                          NSLog(@"item 1 selected");
                                                                      }];
    PininterestLikeMenuItem *item2 = [[PininterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                       selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                      selectedBlock:^(void) {
                                                                          NSLog(@"item 2 selcted");
                                                                      }];
    NSArray *subMenus = @[item0, item1, item2];
    
    CGPoint startPoint = [gesture locationInView:self.view];
    
    PininterestLikeMenu *menu = [[PininterestLikeMenu alloc] initWithSubMenus:subMenus withStartPoint:startPoint];
    
    [menu show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
