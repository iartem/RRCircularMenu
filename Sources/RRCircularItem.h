//
//  RRCircularItem.h
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/5/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

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
