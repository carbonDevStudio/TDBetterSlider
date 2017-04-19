# TDBetterSlider
An iOS Preferences slider replacement with a tap to type entry method

#Usage

I personally use this slider alongside [SettingsKit](https://github.com/mlnlover11/SettingsKit) from mlnlover11, which allows specifier creation via obj-c NSDictionaries.

```objc
#import “TDBetterPSSliderTableCell.h"
```
And within the specifiers array, use it like so:
```objc
NSArray *specs = @[
                    @{
                      @"cell": @"PSGroupCell”
                    },
                    @{
                        @"cell": @"PSSliderCell",
                        @"default": @15,//default value
                        @"min": @7,//minimum allowed value
                        @"max": @60,//maximum allowed value
                        @"showValue": @YES,//required to have space for button
                        @“allowDecimal”: @YES,//optional to force show decimal button
                        @"name": @“SPECIFIER_NAME”,//optional
                        @"defaults": @“PREFERENCE_FILE_NAME”,//required
                        @"key": @“SLIDER_PREFERENCES_KEY”,//required
                        @"PostNotification": @“RELOAD_SETTINGS_NOTIFICATION_STRING”,//optional
                        @"cellClass": @“TDBetterPSSliderTableCell”//most important part!
                    }
                    ];
```
The point (decimal) button will automatically show if the difference between the max and min is less than 10. You can force it visible or not with the “allowDecimal” specifier key.

The negate (minus) button will automatically show if the minimum value is a negative number.

This should work with normal .plist preference bundles, just use the same keys in the example above.

#Example:

![screenshot](http://i.imgur.com/46bLwBJ.png)
