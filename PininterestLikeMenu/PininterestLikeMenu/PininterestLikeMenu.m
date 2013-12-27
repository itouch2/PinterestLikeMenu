//
//  PininterestLikeMenu.m
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "PininterestLikeMenu.h"

#define kMaxAngle        M_PI_2
#define kMaxLength       (95)
#define kLength          (75)
#define kBounceLength    (18)
#define kPulseLength     (60)

@interface PininterestLikeMenu ()

@property (nonatomic, strong) NSArray *subMenus;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIImageView *startImageView;

@end

@implementation PininterestLikeMenu

- (id)initWithSubMenus:(NSArray *)subMenus withStartPoint:(CGPoint)point
{
    if (self = [super init])
    {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        self.subMenus = subMenus;
        
        self.startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        point.x = point.x < 20 ? 20 : point.x;
        point.x = point.x > (320 - 20) ? (320 - 20) : point.x;
        
        self.startPoint = point;
        self.startImageView.center = point;
        self.startImageView.image = [UIImage imageNamed:@"center"];
        
        [self addSubview:self.startImageView];
        
        // TODO: CONSIDER SUBMENUS > 3
        for (int i = 0; i < self.subMenus.count; i++)
        {
            ((UIView *)(self.subMenus[i])).center = self.startPoint;

            [self addSubview:self.subMenus[i]];
        }
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self appear];
}

- (void)updataLocation:(CGPoint)touchedPoint
{
    int closestIndex = 0;
    float minDistance = CGFLOAT_MAX;
    
    // find the cloest menu item
    for (int i = 0; i < self.subMenus.count; i++)
    {
        CGPoint floatingPoint = [self floatingPointWithIndex:i];
        
        float distance = [self distanceFromPointX:touchedPoint toPointY:floatingPoint];
        
        if (distance < minDistance)
        {
            minDistance = distance;
            closestIndex = i;
        }
    }
    
    for (int i = 0; i < self.subMenus.count; i++)
    {
        PininterestLikeMenuItem *menuItem = self.subMenus[i];
        
        // the cloest point
        if (i == closestIndex)
        {
            CGPoint floatingPoint = [self floatingPointWithIndex:i];
            float currentDistance = [self distanceFromPointX:touchedPoint toPointY:floatingPoint];
            currentDistance = currentDistance > kMaxLength ? kMaxLength : currentDistance;
            float step = (currentDistance / kMaxLength) * (kMaxLength - kLength);
            
            [UIView animateWithDuration:0.1 animations:^{
                [self moveWithIndex:i offsetOfFloatingPoint:step];
            }];
            
            float distance = [self distanceFromPointX:touchedPoint toPointY:menuItem.center];
            
            // if close enough, highlight the point
            if (distance < kPulseLength)
            {
                menuItem.selected = YES;
            }
            else
            {
                menuItem.selected = NO;
            }
        }
        else
        {
            // back to init state
            [UIView animateWithDuration:0.20 animations:^{
                [self setThePostion:i];
            } completion:^(BOOL finished) {
                menuItem.selected = NO;
            }];
        }
    }

}

- (void)finished:(CGPoint)location
{
    for (int i = 0; i < self.subMenus.count; i++)
    {
        PininterestLikeMenuItem *menuItem = self.subMenus[i];
        if (menuItem.selected)
        {
            if (menuItem.selectedBlock)
            {
                menuItem.selectedBlock();
            }
            break;
        }
    }
    [self disappear];
}

- (void)moveWithIndex:(int)index offsetOfFloatingPoint:(float)offset
{
    UIView *menuItem = (UIView *)self.subMenus[index];
    CGPoint floating = [self floatingPointWithIndex:index];
    float radian = [self radianWithIndex:index];
    radian = radian - M_PI;
    float x = floating.x + offset * cos(radian);
    float y = floating.y + offset * sin(radian);
    menuItem.center = CGPointMake(x, y);
}

- (void)setThePostion:(int)index
{
    float radian = [self radianWithIndex:index];
    float x = kLength * cos(radian);
    float y = kLength * sin(radian);
    UIView *view = self.subMenus[index];
    view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
}

- (CGPoint)floatingPointWithIndex:(int)index
{
    float radian = [self radianWithIndex:index];
    float x = kMaxLength * cos(radian);
    float y = kMaxLength * sin(radian);
    CGPoint point = CGPointMake(_startPoint.x + x, _startPoint.y + y);
    return point;
}

- (float)radianWithIndex:(int)index
{
    NSUInteger count = self.subMenus.count;
    
    // from 3/2 -> 2/2  0 -> 320 (20 -> 300)
    
    float startRadian = M_PI_2 * 3 - ((self.startPoint.x - 20) / (320 - 20 * 2)) * M_PI_2;
    float step = kMaxAngle / (count - 1);
    float radian = startRadian + index * step;

    return radian;
}

- (void)appear
{
    for (int i = 0; i < self.subMenus.count; i++)
    {
        [self pulseTheMenuAtIndex:i];
    }
}

- (void)disappear
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)pulseTheMenuAtIndex:(int)index
{
    UIView *view = (UIView *)self.subMenus[index];
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         float radian = [self radianWithIndex:index];
                         float y =  (kLength + kBounceLength) * sin(radian);
                         float x = (kLength + kBounceLength) * cos(radian);
                         view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              
                             float radian = [self radianWithIndex:index];
                             float y = kLength * sin(radian);
                             float x =  kLength * cos(radian);
                             view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
                                              
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
}

- (float)distanceFromPointX:(CGPoint)pointX toPointY:(CGPoint)pointY
{
    float distance = 0;
    float offsetX = pointX.x - pointY.x;
    float offsetY = pointX.y - pointY.y;
    distance = sqrtf(pow(offsetX, 2) + pow(offsetY, 2));
    return distance;
}

@end
