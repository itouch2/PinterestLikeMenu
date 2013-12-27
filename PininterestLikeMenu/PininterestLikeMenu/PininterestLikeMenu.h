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

- (id)initWithSubMenus:(NSArray *)subMenus withStartPoint:(CGPoint)point;

- (void)show;

- (void)updataLocation:(CGPoint)location;
- (void)finished:(CGPoint)location;

@end
