
#import <Preferences/Preferences.h>
#import <Preferences/PSSliderTableCell.h>
#import <UIKit/UIKit.h>

@interface TDBetterPSSliderTableCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
    UIAlertView * alert;
}
-(void) presentPopup;
-(void) typeMinus;
-(void) typePoint;

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier;
@end
