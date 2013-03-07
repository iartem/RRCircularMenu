//
//  RRCircularMenu.m
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/5/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import "RRCircularMenu.h"
#import "RRCircularItem.h"
#import "RRCircularMenuLabel.h"
#import "RRCircularSlider.h"
#import "Helpers.h"
#import <QuartzCore/QuartzCore.h>

@implementation RRCircularMenu {
    NSMutableArray *items;
    
    float angleFromDegrees, angleToDegrees, angleStep;
    float radius, textRadius, iconRadius;
    UIFont *font;
    
    RRCircularMenuLabel *label;
    
    RRCircularSlider *slider;
}

- (void) dealloc {
    items = _release(items);
    label = _release(label);
    slider = _release(slider);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.clipsToBounds = YES;
        [self setUpItems];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

# pragma mark - Set up

// Put your items here
- (void) setUpItems {
    angleFromDegrees = -190, angleToDegrees = 10, angleStep = (angleToDegrees - angleFromDegrees) / 6;
    radius = 146, textRadius = 130, iconRadius = 85;
    font = [UIFont systemFontOfSize:14];
    
    items = _release(items);
    items = [[NSMutableArray alloc] init];
    float currentAngle = angleFromDegrees;
    int index = 0;
    for (NSString *title in @[@"Time", @"Distance", @"Speed", @"HR", @"Calories", @"Route"]) {
        [self addItem:title from:currentAngle to:currentAngle + angleStep index:index++];
        currentAngle += angleStep;
    }
    [[items objectAtIndex:0] setFirstOne:YES];
    [[items lastObject] setLastOne:YES];
    
    // disable last border for symmetry
    [[items lastObject] setBorderWidth:0];
    
    // Add center label
    label = [[RRCircularMenuLabel alloc] initWithFrame:CGRectMake(10 + (self.frame.size.width - 20) / 2 - 50, self.frame.size.height - 50 - 20, 100, 100)];
//    label.text = @"EVERY\n5 min";
    [self addSubview:label];
    
    // Add slider
    slider = [[RRCircularSlider alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.width)];
    slider.angleFrom = angleFromDegrees;
    slider.angleTo = angleToDegrees;
    slider.step = angleStep;
    [slider setValue:0 animated:NO];
    [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slider];
}

- (void) addItem:(NSString *)title from:(float)angleFrom to:(float)angleTo index:(int)index{
    RRCircularItem *item = [[RRCircularItem alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height)];
    item.tag = index;
    item.text = title;
    item.radius = radius;
    item.textRadius = textRadius;
    item.iconRadius = iconRadius;
    item.center = CGPointMake((self.frame.size.width - 20) / 2, self.frame.size.height - 20);
    item.angleFrom = angleFrom;
    item.angleTo = angleTo;
    item.activeImage = [UIImage imageNamed:[[title lowercaseString] stringByAppendingString:@"@2x.png"]];
    item.inactiveImage = [UIImage imageNamed:[[title lowercaseString] stringByAppendingString:@".off@2x.png"]];
    [items addObject:item];
    [self addSubview:item];
    [item release];
}

# pragma mark - Events handling

- (void) sliderValueChanged {
    // do not notify delegate when animating
    if (slider.value < 0) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChanged:)]) [_delegate sliderValueChanged:slider];
}

- (void) handleTap:(UIGestureRecognizer *)recognizer {
    if ([label hitInside:[recognizer locationInView:label]]) {
        [label setActive:!label.active];
        [label setNeedsDisplay];
        if (_delegate && [_delegate respondsToSelector:@selector(menuLabel:didChangeActive:)]) [_delegate menuLabel:label didChangeActive:label.active];
    } else {
        for (RRCircularItem *item in items) {
            CGPoint point = [recognizer locationInView:item];
            if ([item hitInside:point] && (!_delegate || ![_delegate respondsToSelector:@selector(ignoreClickFor:)] || ![_delegate ignoreClickFor:item])) {
                [item setActive:!item.active];
                [item setNeedsDisplay];
                if (_delegate && [_delegate respondsToSelector:@selector(menuItem:didChangeActive:)]) [_delegate menuItem:item didChangeActive:item.active];
            }
        }
    }
}

# pragma mark - Getters / Setters

- (void) setItem:(int)index active:(BOOL)active {
    [[items objectAtIndex:index] setActive:active];
    [[items objectAtIndex:index] setNeedsDisplay];
}

- (BOOL) isItemActive:(int)index {
    return [[items objectAtIndex:index] active];
}

- (void) setLabelActive:(BOOL)active {
    label.active = active;
    [label setNeedsDisplay];
}

- (BOOL) isLabelActive {
    return label.active;
}

- (void) setLabelText:(NSString *)text {
    label.text = text;
    [label setNeedsDisplay];
}

- (void) setSliderValue:(int)value {
    [slider setValue:value];
}

- (void) setSliderValue:(int)value animated:(BOOL)animated{
    [slider setValue:value animated:animated];
}

- (int) sliderValue {
    return slider.value;
}

# pragma mark - Drawing and Animations

- (void) showWithAnimationBlock:(void(^)(void))block settingSliderTo:(int)value {
    // Animation takes four steps performed one-by-one:
    // 1. Bubble up label, then 2:
    // 2. Rotate segments around their center, then 3:
    // 3. Scale up rainbow, then 4:
    // 4. Rotate slider thumb to its position
    
    float duration1 = 0.5;
    float duration2 = 0.5;
    float duration3 = 0.5;
    
    // 1. Bubble up label
    self.hidden = NO;
    label.alpha = 0;
    label.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:duration1 / 2 animations:^{
        label.alpha = 0.8;
        label.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration1 / 2 animations:^{
            label.alpha = 1;
            label.transform = CGAffineTransformIdentity;
        }];
    }];
    
    // 2. Rotate segments around their center
    float step = M_PI / 180 * fabsf(angleFromDegrees - angleToDegrees) / items.count;
    for (int i = 0; i < items.count; i++) {
        float angle = - (i + 1) * step;
        RRCircularItem *item = [items objectAtIndex:i];
        RRViewSetAnchorPoint(item, CGPointMake(item.center.x / item.frame.size.width, item.center.y / item.frame.size.height));
        [item setTransform:CGAffineTransformMakeRotation(angle)];
        [item setAlpha:0];
    }
    [UIView animateWithDuration:duration2
                          delay:duration1 / 3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (RRCircularItem *item in items) {
                             [item setTransform:CGAffineTransformIdentity];
                             [item setAlpha:1];
                         }
                         if (block) block();
                     } completion:^(BOOL finished) {
                         slider.hidden = NO;
                     }];
    
    // 3. Scale up rainbow
    [slider removeFromSuperview];
    [self insertSubview:slider belowSubview:[items objectAtIndex:0]];
    [slider setValue:-1 animated:NO];
    
    slider.alpha = 0;
    slider.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:duration3 * 2 / 3
                          delay:duration1 / 3
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         slider.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         slider.alpha = 1;
                     } completion:^(BOOL finished) {
                         [slider removeFromSuperview];
                         [self addSubview:slider];
                         [UIView animateWithDuration:duration3 * 1 / 3 animations:^{
                             slider.transform = CGAffineTransformIdentity;
                         } completion:^(BOOL finished) {
                             // 4. Rotate slider thumb to its position
                             [slider setValue:value animated:YES];
                         }];
                     }];
}

- (void) hideWithAnimationBlock:(void(^)(void))block {
    // Reversed sequence from 'show' with faster timing
    
    float duration1 = 0.4;
    float duration2 = 0.4;
    
    // 1. Scale down whole slider
    [slider setValue:-1 animated:YES];
    [UIView animateWithDuration:duration1 / 2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         slider.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         slider.alpha = 0.5;
                     } completion:^(BOOL finished) {
                         [slider removeFromSuperview];
                         [self insertSubview:slider belowSubview:[items objectAtIndex:0]];

                         [UIView animateWithDuration:duration1 / 4 animations:^{
                             slider.transform = CGAffineTransformMakeScale(0.8, 0.8);
                             slider.alpha = 0;
                         } completion:^(BOOL finished) {
                             slider.hidden = YES;
                             slider.transform = CGAffineTransformIdentity;
                         }];
                     }];

    
    // 2. Rotate segments around their center
    float step = M_PI / 180 * fabsf(angleFromDegrees - angleToDegrees) / items.count;
    [UIView animateWithDuration:duration2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (int i = 0; i < items.count; i++) {
                             RRCircularItem *item = [items objectAtIndex:i];
                             RRViewSetAnchorPoint(item, CGPointMake(item.center.x / item.frame.size.width, item.center.y / item.frame.size.height));
                             [item setTransform:CGAffineTransformMakeRotation(- (i + 1) * step)];
                             [item setAlpha:0];
                         }
                         if (block) block();
                     } completion:^(BOOL finished) {
                         // remove menu from view hierarchy here beacuse it's the latter block of all animations
                        [self removeFromSuperview];
                     }];

    // 3. Bubble down label
    [UIView animateWithDuration:duration1 / 2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         label.alpha = 0.8;
                         label.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:duration1 / 4 animations:^{
                             label.alpha = 0;
                             label.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         }];
                     }];
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // This is a circular background. We need it because circle center is a bit above bottom of the screen, 
    // there are no segments in the lower part of circle
//    CGContextAddEllipseInRect(ctx, CGRectMake(10 + (self.frame.size.width - 20) / 2 - 150 + 10 + 1, self.frame.size.height - 160 + 1, 278, 278));
//    CGContextSetFillColorWithColor(ctx, label.backColor.CGColor);
//    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

@end
