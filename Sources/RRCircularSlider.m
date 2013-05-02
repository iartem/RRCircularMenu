//
//  RRCircularSlider.m
//  RRCircularMenu
//
//  Created by Artem Salpagarov on 3/6/13.
//  Copyright (c) 2013 Artem Salpagarov. All rights reserved.
//

#import "RRCircularSlider.h"
#import "Helpers.h"
#import <QuartzCore/QuartzCore.h>

@implementation RRCircularSlider {
    CGImageRef gradient;
    UIButton *thumb;
    
    BOOL inThumb;
    
    float radius;
    float offset;
    CGPoint center;
    CGSize circleSize;
}

@synthesize angleFrom = _angleFrom, angleTo = _angleTo, step = _step, value = _value;

- (void) dealloc {
    CGImageRelease(gradient);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        offset = 12;
        radius = frame.size.width / 2 - offset;
        center = CGPointMake(offset + radius, offset + radius);
        
        self.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *locations = [[NSMutableArray alloc] init];

        [colors addObject:(id)[UIColor colorWithRed:0.988 green:0.949 blue:0.298 alpha:1].CGColor];
        [colors addObject:(id)[UIColor colorWithRed:0.000 green:0.718 blue:0.271 alpha:1].CGColor];
        [colors addObject:(id)[UIColor colorWithRed:0.000 green:0.882 blue:0.976 alpha:1].CGColor];
        [colors addObject:(id)[UIColor colorWithRed:0.000 green:0.882 blue:0.976 alpha:1].CGColor];
        [colors addObject:(id)[UIColor colorWithRed:0.000 green:0.718 blue:0.271 alpha:1].CGColor];
        [colors addObject:(id)[UIColor colorWithRed:0.988 green:0.949 blue:0.298 alpha:1].CGColor];

        [locations addObject:[NSNumber numberWithFloat:0]];
        [locations addObject:[NSNumber numberWithFloat:0.1666]];
        [locations addObject:[NSNumber numberWithFloat:0.3333]];
        [locations addObject:[NSNumber numberWithFloat:0.6666]];
        [locations addObject:[NSNumber numberWithFloat:0.8333]];
        [locations addObject:[NSNumber numberWithFloat:1]];
        
        CGImageRef fullGradient = [self newImageGradientInRect:self.bounds colors:colors locations:locations];
        CGImageRef maskRef = [self borderMask];
        
        CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                            CGImageGetHeight(maskRef),
                                            CGImageGetBitsPerComponent(maskRef),
                                            CGImageGetBitsPerPixel(maskRef),
                                            CGImageGetBytesPerRow(maskRef),
                                            CGImageGetDataProvider(maskRef), NULL, false);
        gradient = CGImageCreateWithMask(fullGradient, mask);

        CGImageRelease(mask);
        CGImageRelease(fullGradient);
        
        [colors release];
        [locations release];

        
        UIImage *thumbImage = [self thumbImage];
        thumb = [[UIButton alloc] initWithFrame:CGRectZero];
        [thumb setImage:thumbImage forState:UIControlStateNormal];
        [thumb setImage:thumbImage forState:UIControlStateSelected];
        [thumb setImage:thumbImage forState:UIControlStateHighlighted];
        [thumb addTarget:self action:@selector(thumbPressed) forControlEvents:UIControlEventTouchDragInside];
        [self addSubview:thumb];
        
//        RRViewSetAnchorPoint(thumb, CGPointMake(0.5, <#CGFloat y#>))


        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        [pan release];
    }
    return self;
}

# pragma mark - Events handling

- (void) thumbPressed {
    inThumb = YES;
}

- (void) handlePan:(UIPanGestureRecognizer *)pan {
    if (!inThumb) return;
    
	CGPoint point = [pan locationInView:self];
	switch (pan.state) {
		case UIGestureRecognizerStateChanged: {
//            CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 10);
            float x = point.x - self.bounds.origin.x - center.x;
            float y = -point.y + self.bounds.origin.y + center.y;
            float hypot = hypotf(x, y);
            
            float angle;
            if (x / hypot > 0) {
                angle = - asinf(y / hypot);
            } else if (x / hypot < 0) {
                angle = asinf(y / hypot) - M_PI;
            } else {
                angle = - M_PI_2;
            }

            if (angle < _angleFrom) angle = _angleFrom + _step / 2;
            if (angle > _angleTo) angle = _angleTo - _step / 2;

            angle = fabs(_angleFrom - angle) - _step / 2;
            self.value = roundf(angle / _step);

            break;
		}
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            inThumb = NO;
            break;
		default:
			break;
	}

}

# pragma mark - Getters and setters

- (void) setAngleTo:(float)angleTo {
    _angleTo = M_PI * angleTo / 180;
}

- (void) setAngleFrom:(float)angleFrom {
    _angleFrom = M_PI * angleFrom / 180;
}

- (void) setStep:(float)step {
    _step = M_PI * step / 180;
}

- (void) setValue:(int)value {
    [self setValue:value animated:YES];
}

- (CGFloat) angleBetweenThreePoints:(CGPoint)centerPoint p1:(CGPoint)p1 p2:(CGPoint)p2 {
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
	return angle;
}

- (void) setValue:(int)value animated:(BOOL)animated {
    [self setValue:value animated:animated notifying:YES];
}

- (void) setValue:(int)value animated:(BOOL)animated notifying:(BOOL)notifying {
    if (_value == value && animated) return;
    
    int change = value - _value;
    _value = value;
    
    float x = offset + (1 + cosf(_angleFrom + (value + 0.5) * _step)) * radius;
    float y = offset + (1 + sinf(_angleFrom + (value + 0.5) * _step)) * radius - 10;
    
    if (animated) {
        float currentAngle = [self angleBetweenThreePoints:CGPointMake(center.x, center.y - 10)
                                                        p1:CGPointMake(thumb.frame.origin.x + 20, thumb.frame.origin.y + 20)
                                                        p2:CGPointMake(center.x + radius, center.y - 10)];
        float newAngle = [self angleBetweenThreePoints:CGPointMake(center.x, center.y - 10)
                                                    p1:CGPointMake(x, y)
                                                    p2:CGPointMake(center.x + radius, center.y - 10)];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, nil, center.x, center.y - 10, radius, currentAngle, newAngle, change < 0);
        animation.path=path;
        CGPathRelease(path);
        
        // set the animation properties
        animation.duration = 0.2;
        animation.removedOnCompletion = NO;
        animation.autoreverses = NO;
        animation.rotationMode = kCAAnimationRotateAutoReverse;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [animation setValue:[NSString stringWithFormat:@"%f,%f", x, y] forKey:@"x,y"];
        
        [thumb.layer addAnimation:animation forKey:@"position"];
    } else {
        thumb.frame = CGRectMake(x - 20, y - 20, 40, 40);
    }
    if (notifying) [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    NSArray *comps = [[theAnimation valueForKey:@"x,y"] componentsSeparatedByString:@","];
    [thumb.layer removeAnimationForKey:@"position"];
    thumb.frame = CGRectMake([[comps objectAtIndex:0] floatValue] - 20, [[comps objectAtIndex:1] floatValue] - 20, 40, 40);
}

- (UIView *) thumb { return thumb; }

# pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGContextTranslateCTM(ctx, center.x, center.y);
//    CGContextRotateCTM(ctx, M_PI_4);
    CGContextDrawImage(ctx, CGRectAdd(self.bounds, -self.bounds.size.width / 2, - self.bounds.size.height / 2 - 10, 0, 0), gradient);
//    CGContextDrawImage(ctx, self.bounds, [self borderMask]);
    
    CGContextRestoreGState(ctx);
}

- (CGImageRef) borderMask {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextAddRect(ctx, self.bounds);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, SLIDER_WIDTH);
    CGContextAddEllipseInRect(ctx, CGRectMake(offset, offset, 2 * radius, 2 * radius));
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // Clean up
    UIGraphicsEndImageContext(); // Clean up
    
    return image.CGImage;
}

- (UIImage *) thumbImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40, 40), NO, 1);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, CGRectMake(8, 8, 24, 24));
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.98 alpha:1].CGColor);
    CGContextFillPath(ctx);
    
    CGContextSetShadowWithColor(ctx, CGSizeZero, 3, [UIColor colorWithWhite:0 alpha:0.2].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.775 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextAddEllipseInRect(ctx, CGRectMake(8, 8, 24, 24));
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    UIGraphicsEndImageContext(); // Clean up
    
    return image;
}

#pragma mark - https://github.com/paiv/AngleGradientLayer

#define byte unsigned char
#define uint unsigned int
#define F2CC(x) ((byte)(255 * x))
#define RGBAF(r,g,b,a) (F2CC(r) << 24 | F2CC(g) << 16 | F2CC(b) << 8 | F2CC(a))
#define RGBA(r,g,b,a) ((byte)r << 24 | (byte)g << 16 | (byte)b << 8 | (byte)a)
#define RGBA_R(c) ((uint)c >> 24 & 255)
#define RGBA_G(c) ((uint)c >> 16 & 255)
#define RGBA_B(c) ((uint)c >> 8 & 255)
#define RGBA_A(c) ((uint)c >> 0 & 255)

static void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount);

- (CGImageRef)newImageGradientInRect:(CGRect)rect colors:(NSArray *)colorsArray locations:(NSArray *)locationsArray{
	int w = CGRectGetWidth(rect);
	int h = CGRectGetHeight(rect);
	int bitsPerComponent = 8;
	int bpp = 4 * bitsPerComponent / 8;
	int byteCount = w * h * bpp;
	
	int colorCount = colorsArray.count;
	int locationCount = 0;
	int* colors = NULL;
	float* locations = NULL;
	
	if (colorCount > 0) {
		colors = calloc(colorCount, bpp);
		int *p = colors;
		for (id cg in colorsArray) {
			float r, g, b, a;
			UIColor *c = [[UIColor alloc] initWithCGColor:(CGColorRef)cg];
			if (![c getRed:&r green:&g blue:&b alpha:&a]) {
				if (![c getWhite:&r alpha:&a]) {
					[c release];
					continue;
				}
				g = b = r;
			}
			[c release];
			*p++ = RGBAF(r, g, b, a);
		}
	}
	if (locationsArray.count > 0 && locationsArray.count == colorCount) {
		locationCount = locationsArray.count;
		locations = calloc(locationCount, sizeof(locations[0]));
		float *p = locations;
		for (NSNumber *n in locationsArray) {
			*p++ = [n floatValue];
		}
	}
	
	byte* data = malloc(byteCount);
	angleGradient(data, w, h, colors, colorCount, locations, locationCount);
	
	if (colors) free(colors);
	if (locations) free(locations);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
	CGContextRef ctx = CGBitmapContextCreate(data, w, h, bitsPerComponent, w * bpp, colorSpace, bitmapInfo);
	CGColorSpaceRelease(colorSpace);
	CGImageRef img = CGBitmapContextCreateImage(ctx);
	CGContextRelease(ctx);
	free(data);
	return img;
}

@end

static inline byte blerp(byte a, byte b, float w)
{
	return a + w * (b - a);
}
static inline int lerp(int a, int b, float w)
{
	return RGBA(blerp(RGBA_R(a), RGBA_R(b), w),
				blerp(RGBA_G(a), RGBA_G(b), w),
				blerp(RGBA_B(a), RGBA_B(b), w),
				blerp(RGBA_A(a), RGBA_A(b), w));
}

void angleGradient(byte* data, int w, int h, int* colors, int colorCount, float* locations, int locationCount)
{
	if (colorCount < 1) return;
	if (locationCount > 0 && locationCount != colorCount) return;
	
	int* p = (int*)data;
	float centerX = (float)w / 2;
	float centerY = (float)h / 2;
	
	for (int y = 0; y < h; y++)
        for (int x = 0; x < w; x++) {
            float dirX = x - centerX;
            float dirY = y - centerY;
            float angle = atan2f(dirY, dirX);
            if (dirY < 0) angle += 2 * M_PI;
            angle /= 2 * M_PI;
            
            int index = 0, nextIndex = 0;
            float t = 0;
            
            if (locationCount > 0) {
                for (index = locationCount - 1; index >= 0; index--) {
                    if (angle >= locations[index]) {
                        break;
                    }
                }
                if (index >= locationCount) index = locationCount - 1;
                nextIndex = index + 1;
                if (nextIndex >= locationCount) nextIndex = locationCount - 1;
                float ld = locations[nextIndex] - locations[index];
                t = ld <= 0 ? 0 : (angle - locations[index]) / ld;
            }
            else {
                t = angle * (colorCount - 1);
                index = t;
                t -= index;
                nextIndex = index + 1;
                if (nextIndex >= colorCount) nextIndex = colorCount - 1;
            }
            
            int lc = colors[index];
            int rc = colors[nextIndex];
            int color = lerp(lc, rc, t);
            *p++ = color;
        }
}


