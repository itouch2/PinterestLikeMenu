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

@property (nonatomic, assign) CGPoint beginLocation;
@property (nonatomic, strong) PininterestLikeMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popPininterestMenu:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
}

- (void)showMenu
{
    if (!self.menu) {
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
        
        self.menu = [[PininterestLikeMenu alloc] initWithSubMenus:subMenus withStartPoint:self.beginLocation];
    }
    
    [self.menu show];

}

- (void)popPininterestMenu:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.window];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.beginLocation = location;
        [self showMenu];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self.menu updataLocation:location];
    }
    else{
        self.beginLocation = CGPointZero;
        [self.menu finished:location];
        self.menu = nil;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
