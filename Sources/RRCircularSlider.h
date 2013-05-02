//
//  RRCircularSlider.h
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/6/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SLIDER_WIDTH 4

@interface RRCircularSlider : UIControl

// These are not configurable, actually. For now it works only for -M_PI .. 0.
@property (nonatomic) float angleFrom, angleTo;
// Angle for one step of thumb
@property (nonatomic) float step;

// Number of steps from angleFrom  
@property (nonatomic) int value;

- (void) setValue:(int)value animated:(BOOL)animated; // notifying = YES
- (void) setValue:(int)value animated:(BOOL)animated notifying:(BOOL)notifying; // notify listeners about value changes

- (UIView *) thumb;
@end
