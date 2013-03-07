//
//  RRCircularMenuLabel.m
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/6/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import "RRCircularMenuLabel.h"
#import "Helpers.h"

@implementation RRCircularMenuLabel

@synthesize active = _active, backColor = _backColor, borderColor = _borderColor, borderWidth = _borderWidth, activeTextColor = _activeTextColor, inactiveTextColor = _inactiveTextColor, font = _font, text = _text;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor clearColor];
        self.font               = [UIFont boldSystemFontOfSize:16];
        self.backColor          = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1]; // #F2F2F2
        self.borderColor        = [UIColor colorWithRed:219.0/255 green:219.0/255 blue:219.0/255 alpha:1]; // #DBDBDB
        self.inactiveTextColor  = [UIColor colorWithRed:219.0/255 green:219.0/255 blue:219.0/255 alpha:1]; // #DBDBDB
        self.activeTextColor    = [UIColor colorWithRed:51.0/255  green:51.0/255  blue:51.0/255  alpha:1]; // #333333
        self.font               = [UIFont boldSystemFontOfSize:16];
        self.borderWidth        = 2;
    }
    return self;
}

- (void) dealloc {
    _backColor = _release(_backColor);
    _borderColor = _release(_borderColor);
    _inactiveTextColor = _release(_inactiveTextColor);
    _activeTextColor = _release(_activeTextColor);
    _font = _release(_font);
    [super dealloc];
}

- (void) drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _backColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);

    CGContextAddEllipseInRect(ctx, self.bounds);
    CGContextFillPath(ctx);
    
    // We need to decrease ellipse size to fit border in bounds
    float shrink = _borderWidth > 2 ? _borderWidth / 2 : 1;
    CGContextAddEllipseInRect(ctx, CGRectAdd(self.bounds, shrink, shrink, -2 * shrink, -2 * shrink));
    CGContextStrokePath(ctx);
    
    CGSize size = [_text sizeWithFont:_font constrainedToSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height - 12) lineBreakMode:NSLineBreakByWordWrapping];
    [_active ? _activeTextColor : _inactiveTextColor setFill];
    [_text drawInRect:CGRectMake((self.bounds.size.width - size.width) / 2, (self.bounds.size.height - size.height) / 2 - 12, size.width, size.height)
             withFont:_font
        lineBreakMode:NSLineBreakByWordWrapping
            alignment:NSTextAlignmentCenter];
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (BOOL) hitInside:(CGPoint)point {
    return hypot(point.x - CGRectGetMidX(self.bounds), point.y - CGRectGetMidY(self.bounds)) < self.bounds.size.width / 2;
}

@end
