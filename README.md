# TDBetterSlider
An iOS Preferences slider replacement with a tap to type entry method

####Usage

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
                        @"default": @15,
                        @"min": @7,
                        @"max": @60,
                        @"showValue": @YES,
                        @"name": @“SPECIFIER_NAME”,
                        @"defaults": @“PREFERENCE_FILE_NAME”,
                        @"key": @“SLIDER_PREFERENCES_KEY”,
                        @"PostNotification": @“RELOAD_SETTINGS_NOTIFICATION_STRING”,
                        @"cellClass": @“TDBetterPSSliderTableCell"
                    }
                    ];
```
