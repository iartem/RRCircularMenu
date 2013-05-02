//
//  RRCircularItem.h
//  RRCircularMenu
//
//  Copyright (C) 2013 Artem Salpagarov

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface RRCircularItem : UIControl

// Whether item is active (activeTextColor of text, active icon, activeColor background) or not 
@property (nonatomic) BOOL active;

// Background color of circle segment (when selected / touched or not)
@property (nonatomic, retain) UIColor *activeColor, *inactiveColor;

// Active / inactive color of title (when selected / touched or not)
@property (nonatomic, retain) UIColor *activeTextColor, *inactiveTextColor;

// Color & width of right border
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic) float borderWidth;

// Title of segment
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIFont *font;

// Optional icons
@property (nonatomic, retain) UIImage *activeImage, *inactiveImage;

// Radius of arc in pixels
@property (nonatomic) float radius;
// Radius of title arc in pixels
@property (nonatomic) float textRadius;
// Center of circle in pixels from self.frame.origin
@property (nonatomic) CGPoint center;
// Size for icons
@property (nonatomic) CGSize iconSize;
@property (nonatomic) float iconRadius;

// Angles in degrees
@property (nonatomic) float angleFrom, angleTo;


// Fixes for first and last item to fill all screen space
@property (nonatomic) BOOL firstOne, lastOne;

- (BOOL) hitInside:(CGPoint)point;

@end
