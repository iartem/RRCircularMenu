//
//  RRCircularMenu.h
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/5/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRCircularItem, RRCircularMenuLabel, RRCircularSlider;

@protocol RRCircularMenuDelegate <NSObject>

- (void) menuItem:(RRCircularItem *)item didChangeActive:(BOOL)active;
- (void) menuLabel:(RRCircularMenuLabel *)label didChangeActive:(BOOL)active;

- (BOOL) ignoreClickFor:(RRCircularItem *)item;

- (void) sliderValueChanged:(RRCircularSlider *)slider;

@end

@interface RRCircularMenu : UIView

@property (nonatomic, assign) id<RRCircularMenuDelegate> delegate;

- (void) setItem:(int)index active:(BOOL)active;
- (BOOL) isItemActive:(int)index;

- (void) setLabelActive:(BOOL)active;
- (BOOL) isLabelActive;
- (void) setLabelText:(NSString *)text;

- (void) setSliderValue:(int)value;
- (void) setSliderValue:(int)value animated:(BOOL)animated;
- (int) sliderValue;

- (void) showWithAnimationBlock:(void(^)(void))block settingSliderTo:(int)value;
- (void) hideWithAnimationBlock:(void(^)(void))block;

@end
