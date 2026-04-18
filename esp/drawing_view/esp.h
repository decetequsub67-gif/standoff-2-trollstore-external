#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "../helpers/Vector3.h"
#import "../helpers/pid.h"
#import "../unity_api/unity.h"

struct ESPBox {
    Vector3 pos;
    CGFloat width;
    CGFloat height;
};

@interface MenuView : UIView
@property (nonatomic, assign) BOOL isLinesEnabled;
@property (nonatomic, assign) BOOL isBoxesEnabled;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)boxTapped;
- (void)lineTapped;
- (void)handlePan:(UIPanGestureRecognizer *)gesture;
- (void)centerMenu;
@end

@interface ESP_View : UIView

@property (nonatomic, strong) MenuView *menuView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)update_data;
@end
