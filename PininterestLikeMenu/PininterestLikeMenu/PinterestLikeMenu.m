//
//  PininterestLikeMenu.m
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "PinterestLikeMenu.h"

#define kMaxAngle        M_PI_2
#define kMaxLength       (95)
#define kLength          (75)
#define kBounceLength    (18)
#define kPulseLength     (60)

static CGFloat distanceBetweenXAndY(CGPoint pointX, CGPoint pointY)
{
    CGFloat distance = 0;
    CGFloat offsetX = pointX.x - pointY.x;
    CGFloat offsetY = pointX.y - pointY.y;
    distance = sqrtf(pow(offsetX, 2) + pow(offsetY, 2));
    return distance;
}

@interface PinterestLikeMenu ()

@property (nonatomic, strong) NSArray *submenus;
@property (nonatomic, strong) UIImageView *startImageView;

@end

@implementation PinterestLikeMenu

- (id)initWithSubmenus:(NSArray *)submenus
{
    return [self initWithSubmenus:submenus startPoint:CGPointZero];
}

- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point
{
    if (self = [super init])
    {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        self.submenus = submenus;
        
        self.startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMenuItemLength, kMenuItemLength)];
        self.startImageView.image = [UIImage imageNamed:@"center"];
        
        self.startPoint = point;
        
        for (int i = 0; i < self.submenus.count; i++)
        {
            ((UIView *)(self.submenus[i])).center = self.startPoint;
            
            [self addSubview:self.submenus[i]];
        }
        
        [self addSubview:self.startImageView];
        
    }
    return self;
}

- (void)setStartPoint:(CGPoint)point
{
    point.x = point.x < kMenuItemLength / 2 ? kMenuItemLength / 2 : point.x;
    point.x = point.x > (320 - kMenuItemLength / 2) ? (320 - kMenuItemLength / 2) : point.x;
    
    _startPoint = point;
    
    _startImageView.center = point;
    
    for (int i = 0; i < self.submenus.count; i++)
    {
        ((UIView *)(self.submenus[i])).center = self.startPoint;
    }
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
    for (int i = 0; i < self.submenus.count; i++)
    {
        CGPoint floatingPoint = [self floatingPointWithIndex:i];
        
        CGFloat distance = distanceBetweenXAndY(touchedPoint, floatingPoint);
        
        if (distance < minDistance)
        {
            minDistance = distance;
            closestIndex = i;
        }
    }
    
    for (int i = 0; i < self.submenus.count; i++)
    {
        PinterestLikeMenuItem *menuItem = self.submenus[i];
        
        // the cloest point
        if (i == closestIndex)
        {
            CGPoint floatingPoint = [self floatingPointWithIndex:i];
            CGFloat currentDistance = distanceBetweenXAndY(touchedPoint, floatingPoint);
            currentDistance = currentDistance > kMaxLength ? kMaxLength : currentDistance;
            float step = (currentDistance / kMaxLength) * (kMaxLength - kLength);
            
            [UIView animateWithDuration:0.1 animations:^{
                [self moveWithIndex:i offsetOfFloatingPoint:step];
            }];
            
            CGFloat distance = distanceBetweenXAndY(touchedPoint, floatingPoint);
            
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

- (void)finished
{
    for (int i = 0; i < self.submenus.count; i++)
    {
        PinterestLikeMenuItem *menuItem = self.submenus[i];
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
    UIView *menuItem = (UIView *)self.submenus[index];
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
    UIView *view = self.submenus[index];
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
    NSUInteger count = self.submenus.count;
    
    // from 3/2 -> 2/2  0 -> 320 (20 -> 300)
    
    float startRadian = M_PI_2 * 3 - ((self.startPoint.x - 20) / (320 - 20 * 2)) * M_PI_2;
    float step = kMaxAngle / (count - 1);
    float radian = startRadian + index * step;

    return radian;
}

- (void)appear
{
    for (int i = 0; i < self.submenus.count; i++)
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
    UIView *view = (UIView *)self.submenus[index];
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

@end
