

#import "TDBetterPSSliderTableCell.h"

#define kPrefsPath @"/var/mobile/Library/Preferences/"
#define kTDBSAlertTag 572392
#define kTDBSErrorAlertTag 9774298

@interface PSTableCell ()
@property(retain, nonatomic) PSSpecifier *specifier;
@end

@implementation TDBetterPSSliderTableCell

- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:arg3];
    
    if (self) {
        
        CGRect frame = [self frame];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(frame.size.width-50, 0, 50, frame.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setTitle:@"" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(presentPopup) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)presentPopup
{
    alert = [[UIAlertView alloc] initWithTitle:self.specifier.name
                          message:[NSString stringWithFormat:@"Please enter a value between %.01f and %.01f.", [[self.specifier propertyForKey:@"min"] floatValue], [[self.specifier propertyForKey:@"max"] floatValue]]
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Enter"
                          , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kTDBSAlertTag;
    [alert show];
    
    [[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] resignFirstResponder];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    
    BOOL needsNegate = [[self.specifier propertyForKey:@"min"] floatValue]<0;
    BOOL needsPoint = NO;
    
    if ([self.specifier propertyForKey:@"allowDecimal"]) {
        needsPoint = [[self.specifier propertyForKey:@"allowDecimal"] boolValue];
    } else {
        needsPoint = [[self.specifier propertyForKey:@"max"] floatValue] - [[self.specifier propertyForKey:@"min"] floatValue] <= 10;
    }
    
    if( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && (needsNegate || needsPoint)) {
        
        UIToolbar* toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        UIBarButtonItem* buttonOne = [[UIBarButtonItem alloc] initWithTitle:@"Negate" style:UIBarButtonItemStylePlain target:self action:@selector(typeMinus)];
        UIBarButtonItem* buttonTwo = [[UIBarButtonItem alloc] initWithTitle:@"Point" style:UIBarButtonItemStylePlain target:self action:@selector(typePoint)];
        
        NSArray* buttons = nil;
        
        if(needsPoint && needsNegate) {
            buttons = [NSArray arrayWithObjects:buttonOne, buttonTwo, nil];
        } else if (needsPoint) {
            buttons = [NSArray arrayWithObjects: buttonTwo, nil];
        } else if (needsNegate) {
            buttons = [NSArray arrayWithObjects: buttonOne, nil];
        }
        
        [toolBar setItems:buttons animated:NO];
        [[alert textFieldAtIndex:0] setInputAccessoryView:toolBar];
    }
    
    [[alert textFieldAtIndex:0] becomeFirstResponder];
}

-(void) typeMinus
{
    if (alert) {
        NSString* text = [alert textFieldAtIndex:0].text;
        
        if ([text hasPrefix:@"-"]) {
            [alert textFieldAtIndex:0].text = [text substringFromIndex:1];
        } else {
            [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"-%@", text];
        }
    }
}

-(void) typePoint
{
    if (alert) {
        NSString* text = [alert textFieldAtIndex:0].text;
        [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%@.", text];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTDBSAlertTag) {
        
        if(buttonIndex == 1) {
            CGFloat value = [[alertView textFieldAtIndex:0].text floatValue];
            
            if (value <= [[self.specifier propertyForKey:@"max"] floatValue] && value >= [[self.specifier propertyForKey:@"min"] floatValue]) {
                [self setValue:[NSNumber numberWithFloat:value]];
                [self setPreferenceValue:@(value) specifier:self.specifier];
                
            } else {
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Ensure you enter a valid value."
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil
                                            , nil];
                errorAlert.tag = kTDBSErrorAlertTag;
                [errorAlert show];
            }
        }
        
        [[alertView textFieldAtIndex:0] resignFirstResponder];
    } else if (alertView.tag == kTDBSErrorAlertTag) {
        [self presentPopup];
    }
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    
    NSString *path = [kPrefsPath stringByAppendingString:specifier.properties[@"defaults"]];

    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    
    if([defaults writeToFile:path atomically:YES])
    {
        //all good do nothing
    } else{
        //NSLog(@"FAILED WRITING SETTINGS");
    }
    
    CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

@end
