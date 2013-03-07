//
//  RRCircularMenuLabel.h
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/6/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRCircularMenuLabel : UIView

@property (nonatomic) BOOL active;

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *backColor;
@property (nonatomic) float borderWidth;

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *activeTextColor;
@property (nonatomic, retain) UIColor *inactiveTextColor;
@property (nonatomic, retain) UIFont *font;

- (BOOL) hitInside:(CGPoint)point;

@end
