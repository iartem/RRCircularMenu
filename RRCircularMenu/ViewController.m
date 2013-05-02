//
//  ViewController.m
//  RRCircularMenu
//
//  Copyright (C) 2013 Artem Salpagarov

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ViewController.h"
#import "RRCircularItem.h"
#import "RRCircularMenu.h"
#import "RRCircularMenuLabel.h"
#import "RRCircularSlider.h"

@interface ViewController ()

@end

@implementation ViewController {
    RRCircularMenu *menu;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Open menu" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, self.view.frame.size.height - 45, 120, 40)];
    [button addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}

- (void) openMenu {
    if (menu) {
        [menu hideWithAnimationBlock:^{
            self.view.backgroundColor = [UIColor whiteColor];
        }];
        [menu release], menu = nil;
    } else {
        menu = [[RRCircularMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
        menu.delegate = self;
        
        [self.view addSubview:menu];
        [menu showWithAnimationBlock:^{
            self.view.backgroundColor = [UIColor darkGrayColor];
        } settingSliderTo:3];
    }
}

# pragma mark - Menu Delegate methods

- (void) menuItem:(RRCircularItem *)item didChangeActive:(BOOL)active {
    NSLog(@"Item %@ did change state to %d", item.text, active);
    if (active && ![menu isLabelActive]) {
        [menu setLabelActive:YES];
        [menu setSliderValue:1];
    } else if (!active && [menu isLabelActive]) {
        BOOL hasActive = NO;
        for (int i = 0; i < 6; i++) hasActive |= [menu isItemActive:i];
        if (!hasActive) {
            [menu setLabelActive:NO];
            [menu setSliderValue:0 animated:NO];
        }
    }
}
- (void) menuLabel:(RRCircularMenuLabel *)label didChangeActive:(BOOL)active {
    NSLog(@"Label did change state to %d (%@)", active, label.text);
    if (active && [menu sliderValue] == 0) {
        [menu setSliderValue:1];
        [menu setItem:0 active:YES];
    } else if (!active && [menu sliderValue] != 0) {
        [menu setSliderValue:0 animated:NO];
        for (int i = 0; i < 6; i++) [menu setItem:i active:NO];
    }
}

- (BOOL) ignoreClickFor:(RRCircularItem *)item {
    NSLog(@"Checking whether to ignore click for item %@", item.text);
    return NO;
}

- (void) sliderValueChanged:(RRCircularSlider *)slider {
    NSLog(@"Slider value changed to %d", slider.value);
    if (slider.value == 0) {
        [menu setLabelActive:NO];
        [menu setLabelText:@"CUES\nOFF"];
        for (int i = 0; i < 6; i++) [menu setItem:i active:NO];
    } else {
        [menu setLabelActive:YES];
        
        if (slider.value == 1) {
            [menu setLabelText:@"AUTO-\nMAGICAL"];
        } else if (slider.value == 2) {
            [menu setLabelText:@"EVERY\n5 min"];
        } else if (slider.value == 3) {
            [menu setLabelText:@"EVERY\n10 min"];
        } else if (slider.value == 4) {
            [menu setLabelText:@"EVERY\n1 km"];
        } else if (slider.value == 5) {
            [menu setLabelText:@"EVERY\n3 km"];
        }
    }
}


@end
