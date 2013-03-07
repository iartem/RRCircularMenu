//
//  RRCircularItem.m
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/5/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import "RRCircularItem.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "Helpers.h"

@implementation RRCircularItem

@synthesize active = _active;
@synthesize activeColor = _activeColor, inactiveColor = _inactiveColor, activeTextColor = _activeTextColor, inactiveTextColor = _inactiveTextColor, borderColor = _borderColor;
@synthesize borderWidth = _borderWidth, radius = _radius, textRadius = _textRadius, center = _center, angleFrom = _angleFrom, angleTo = _angleTo, iconSize = _iconSize, iconRadius = _iconRadius;

@synthesize text = _text, font = _font, activeImage = _activeImage, inactiveImage = _inactiveImage;

@synthesize firstOne = _firstOne, lastOne = _lastOne;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor clearColor];
        self.activeColor        = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]; // #F2F2F2
        self.inactiveColor      = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]; // #DBDBDB
        self.borderColor        = [UIColor colorWithRed:219.0/255 green:219.0/255 blue:219.0/255 alpha:1]; // #DBDBDB
        self.inactiveTextColor  = [UIColor colorWithRed:219.0/255 green:219.0/255 blue:219.0/255 alpha:1]; // #DBDBDB
        self.activeTextColor    = [UIColor colorWithRed:51.0/255  green:51.0/255  blue:51.0/255  alpha:1]; // #333333
        self.borderWidth        = 2;
        self.radius             = 300;
        self.angleFrom          = -100;
        self.angleTo            = 100;
        self.font               = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void) dealloc {
    _activeColor = _release(_activeColor);
    _inactiveColor = _release(_inactiveColor);
    _borderColor = _release(_borderColor);
    _inactiveTextColor = _release(_inactiveTextColor);
    _activeTextColor = _release(_activeTextColor);
    _font = _release(_font);
    [super dealloc];
}

# pragma mark - Getters and Setters

- (void) setActive:(BOOL)active {
    _active = active;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) setAngleTo:(float)angleTo {
    _angleTo = M_PI * angleTo / 180;
}

- (void) setAngleFrom:(float)angleFrom {
    _angleFrom = M_PI * angleFrom / 180;
}

# pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIColor *background = _active ? _activeColor : _inactiveColor;
    UIImage *icon       = _active ? _activeImage : _inactiveImage;
    UIColor *title      = _active ? _activeTextColor : _inactiveTextColor;

    CGRect f = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // Center of the circle
    CGContextTranslateCTM(ctx, f.origin.x + _center.x, f.origin.y + _center.y);
    
    // First arc point
    CGPoint from = CGPointMake(cosf(_angleFrom) * _radius, sinf(_angleFrom) * _radius);
    // Last arc point
    CGPoint to   = CGPointMake(cosf(_angleTo) * _radius, sinf(_angleTo) * _radius);
    
    // Draw arc
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, from.x, from.y);
    CGContextAddArc(ctx, 0, 0, _radius, _angleFrom, _angleTo, NO);
    CGContextAddLineToPoint(ctx, 0, 0);

    // Fill arc
    [background setFill];
    CGContextFillPath(ctx);
    
    // Fixes for first segment and last segment to fill all screen space
    if (_firstOne) {
        CGContextAddRect(ctx, CGRectMake(from.x, from.y - (self.frame.size.height - _center.y), _radius, self.frame.size.height - from.y));
        CGContextFillPath(ctx);
    } else if (_lastOne) {
        CGContextAddRect(ctx, CGRectMake(to.x - _radius, to.y - (self.frame.size.height - _center.y), _radius, self.frame.size.height - from.y));
        CGContextFillPath(ctx);
    }
    
    // Draw border
    CGContextMoveToPoint(ctx, to.x, to.y);
    CGContextAddLineToPoint(ctx, 0, 0);
    CGContextSetLineWidth(ctx, _borderWidth);
    [_borderColor setStroke];
    CGContextStrokePath(ctx);
    
    // Draw title
    CGSize size = [_text sizeWithFont:_font];
    float arc = _textRadius * fabs(_angleTo - _angleFrom);
    float offset = (arc - size.width) / 2;
    
    CGContextRotateCTM(ctx, M_PI_2 + (_angleTo + _angleFrom) / 2);
    [title setFill];
    [_text drawInRect:CGRectMake(-arc / 2 + offset, -_textRadius - size.height / 2, size.width, size.height) withFont:_font];
    CGContextFillPath(ctx);

    // Draw icon
    // Try to fit icon in segment at iconRadius
    // You should NSLog width and height and use icons of calculated size
    float distance = sqrtf(powf(to.x - from.x, 2) + powf(to.y - from.y, 2));
    float width = floor(distance * _iconRadius / _radius);
    float height = floor(width * icon.size.height / icon.size.width);
    [icon drawInRect:CGRectMake(-width / 2, -_iconRadius - height, width, height)];
//    NSLog(@"width %f, height %f", width,  height);
    
    CGContextRestoreGState(ctx);
    
}

# pragma mark - Events

// Checks whether point is inside circle segment or not
- (BOOL) hitInside:(CGPoint)point {
    float x = point.x - self.bounds.origin.x - _center.x;
    float y = -point.y + self.bounds.origin.y + _center.y;
    float hypot = hypotf(x, y);
    if (hypot > _radius) return NO;
    
    float angle;
    if (x / hypot > 0) {
        angle = - asinf(y / hypot);
    } else if (x / hypot < 0) {
        angle = asinf(y / hypot) - M_PI;
    } else {
        angle = - M_PI_2;
    }
    
    return angle > _angleFrom && angle < _angleTo;
}

@end
