RRCircularMenu
==============

Menu + slider, all circular, animated and 100% Core Graphics (except for icons). As seen in [Run app](http://getrunapp.com).

This component is NOT really configurable, because it's kind of difficult to configure such menus. But you still can set colors, borders, change number of menu items and stuff like that. If you need whole circle of menu items, you'll have to dig into source code and change animations. 

## Introduction
ARC is not enabled for this component, be sure to replace all property retains with strongs and remove dealloc methods if you're going to use it in ARC project.

See demo app for example. It's pretty simple:
```
menu = [[RRCircularMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];
menu.delegate = self;
        
[self.view addSubview:menu];
[menu showWithAnimationBlock:^{
    self.view.backgroundColor = [UIColor darkGrayColor];
} settingSliderTo:3];
```
`showWithAnimationBlock` is used to reveal menu. Supplied animation block helps if you show menu in a modal way, so you could prepare view hierarchy for displaying menu.

Items are being set up in `RRCircularMenu.m`:
```
- (void) setUpItems {
    ...
    for (NSString *title in @[@"Time", @"Distance", @"Speed", @"HR", @"Calories", @"Route"]) {
        [self addItem:title from:currentAngle to:currentAngle + angleStep index:index++];
        currentAngle += angleStep;
    }
    ...
 }
```

Delegate used for all kinds of events:
```
- (void) menuItem:(RRCircularItem *)item didChangeActive:(BOOL)active;
- (void) menuLabel:(RRCircularMenuLabel *)label didChangeActive:(BOOL)active;
- (BOOL) ignoreClickFor:(RRCircularItem *)item;
- (void) sliderValueChanged:(RRCircularSlider *)slider;
```

## Credits

Special thanks to [paiv](https://github.com/paiv) for [AngleGradientLayer](https://github.com/paiv/AngleGradientLayer).
