PininterestLikeMenu
===================

A kind of pop-up menu

**How to:**

First, the menu can be initialized with:

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
        NSArray *submenus = @[item0, item1, item2];
        
        self.menu = [[PininterestLikeMenu alloc] initWithSubmenus:submenus];

To use this pop-up menu, you should add a long press gesture recognizer to the target view with:

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


**A Quick Peek**

![screenshots](https://f.cloud.github.com/assets/4316898/1829452/50e4a22c-72b8-11e3-9158-7f65e7bedd92.gif)
