RRCircularMenu
==============

RRCircularMenu is a circular menu with a rainbow border and a slider. All animations and drawing are 100% Core Graphics (except for icons). As seen in [Run for iPhone](http://getrunapp.com).

![RRCircularMenu screenshot](https://raw.github.com/iartem/RRCircularMenu/master/screenshot.png)

Requirements
---

RRCircularMenu has been developed against the iOS 6 SDK, but may run on iOS 5.

RRCircularMenu *does NOT use ARC*. To use this with ARC, compile with the `-fno-objc-arc` compiler flag.

Using RRMenuController
---

See the demo app for an example. It's pretty simple:

```
 //	1. Import the header
 #import "RRCircularMenu.h"

 // 2. Instantiate a menu object
 menu = [[RRCircularMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180)];

 // 3. Assign a delegate
 menu.delegate = self;
  
 // 4. Install in the view hierarchy      
 [self.view addSubview:menu];
 
 // 5. Display the menu 
 [menu 
   showWithAnimationBlock:^{
    self.view.backgroundColor = [UIColor darkGrayColor];
   } 
   settingSliderTo:3];
```

The method `showWithAnimationBlock:` is used to reveal menu. The supplied animation block helps if you show the menu modally, so you can do things like prepare a view hierarchy for displaying the menu.

Items are set up in `RRCircularMenu.m`:

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

Configuring RRMenuController 
---

This component is NOT really configurable, because it's kind of difficult to configure such menus. But you still can set colors, borders, change number of menu items and stuff like that. If you need whole circle of menu items, you'll have to dig into source code and change animations. 

License 
---

RRMenuController is Copyright (C) 2013 Artem Salpagarov and released under the MIT License:

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Credits
---

Special thanks to [paiv](https://github.com/paiv) for [AngleGradientLayer](https://github.com/paiv/AngleGradientLayer).