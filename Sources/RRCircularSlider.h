//
//  RRCircularSlider.h
//  RRCircularMenu
//
//  Copyright (C) 2013 Artem Salpagarov

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
