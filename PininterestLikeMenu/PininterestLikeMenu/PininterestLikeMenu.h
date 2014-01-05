//
//  PininterestLikeMenu.h
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PininterestLikeMenuItem.h"

@interface PininterestLikeMenu : UIView

@property (nonatomic, assign) CGPoint startPoint;

- (id)initWithSubmenus:(NSArray *)submenus;
- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point;

- (void)show;
- (void)updataLocation:(CGPoint)location;
- (void)finished;

@end
