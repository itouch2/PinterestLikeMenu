//
//  ViewController.m
//  PinterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "ViewController.h"
#import "PinterestLikeMenu.h"

@interface ViewController ()

@property (nonatomic, strong) PinterestLikeMenu *menu;

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

- (PinterestLikeMenu *)menu
{
    if (!_menu)
    {
        PinterestLikeMenuItem *item0 = [[PinterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                           selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                          selectedBlock:^(void) {
                                                                              NSLog(@"item 0 selected");
                                                                          }];
        PinterestLikeMenuItem *item1 = [[PinterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                           selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                          selectedBlock:^(void) {
                                                                              NSLog(@"item 1 selected");
                                                                          }];
        PinterestLikeMenuItem *item2 = [[PinterestLikeMenuItem alloc] initWithImage:[UIImage imageNamed:@"center"]
                                                                           selctedImage:[UIImage imageNamed:@"center-highlighted"]
                                                                          selectedBlock:^(void) {
                                                                              NSLog(@"item 2 selcted");
                                                                          }];
        NSArray *submenus = @[item0, item1, item2];
        
        self.menu = [[PinterestLikeMenu alloc] initWithSubmenus:submenus];

    }
    return _menu;
}

- (void)popPininterestMenu:(UIGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.window];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // set the start point where the menu showing up
        self.menu.startPoint = location;
        [self.menu show];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        [self.menu updataLocation:location];
    }
    else
    {
        [self.menu finished];
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
