//
//  RootViewController.mm
//  TrollSpeed
//
//  Created by Lessica on 2024/1/24.
//

#import <notify.h>

#import "HUDHelper.h"
#import "MainApplication.h"
#import "RootViewController.h"
#import "UIApplication+Private.h"
#import "../esp/drawing_view/obfusheader.h"

static const CGFloat _gAuthorLabelBottomConstraintConstantCompact = -20.f;
static const CGFloat _gAuthorLabelBottomConstraintConstantRegular = -80.f;

@implementation RootViewController {
    UIButton *mainButton;
    UILabel *authorLabel;
    UILabel *poweredByLabel;
    UIImageView *iconImageView;
    NSLayoutConstraint *authorLabelBottomConstraint;
    NSLayoutConstraint *mainButtonCenterYConstraint;
    BOOL isRemoteHUDActive;
}

- (BOOL)isHUDEnabled
{
    return IsHUDEnabled();
}

- (void)setHUDEnabled:(BOOL)enabled
{
    SetHUDEnabled(enabled);
}

- (void)loadView {
    CGRect bounds = UIScreen.mainScreen.bounds;

    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.backgroundColor = [UIColor whiteColor];  

    self.backgroundView = [[UIView alloc] initWithFrame:bounds];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor whiteColor];  
    [self.view addSubview:self.backgroundView];

   
    iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.layer.cornerRadius = 12.0f; 
    iconImageView.layer.masksToBounds = YES;
    iconImageView.backgroundColor = [UIColor clearColor]; 
    iconImageView.image = [UIImage imageNamed:@"icon.png"];
    
    
    [self.backgroundView addSubview:iconImageView];

    mainButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainButton addTarget:self action:@selector(tapMainButton:) forControlEvents:UIControlEventTouchUpInside];
    
if (@available(iOS 15.0, *))
{
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
    config.baseForegroundColor = [UIColor blackColor]; 
    [config setTitleTextAttributesTransformer:^NSDictionary <NSAttributedStringKey, id> * _Nonnull(NSDictionary <NSAttributedStringKey, id> * _Nonnull textAttributes) {
        NSMutableDictionary *newAttributes = [textAttributes mutableCopy];
        [newAttributes setObject:[UIFont boldSystemFontOfSize:32.0] forKey:NSFontAttributeName];
        return newAttributes;
    }];
    [config setCornerStyle:UIButtonConfigurationCornerStyleLarge];
    [mainButton setConfiguration:config];
}
else
{
    [mainButton.titleLabel setFont:[UIFont boldSystemFontOfSize:32.0]];
    [mainButton setBackgroundColor:[UIColor clearColor]]; 
    [mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    mainButton.layer.cornerRadius = 8.0f;
}
    [self.backgroundView addSubview:mainButton];

    UILabel *linkLabel = [[UILabel alloc] init];
    linkLabel.text = @(OBF("t.me/eztap_free"));
    linkLabel.textColor = [UIColor blackColor];
    linkLabel.font = [UIFont systemFontOfSize:14.0f];
    linkLabel.textAlignment = NSTextAlignmentCenter;
    linkLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:linkLabel];

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@(OBF("iOS - %@")), [[UIDevice currentDevice] systemVersion]];
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:versionLabel];

    UILayoutGuide *safeArea = self.backgroundView.safeAreaLayoutGuide;

    [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [mainButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    mainButtonCenterYConstraint = [mainButton.centerYAnchor constraintEqualToAnchor:self.backgroundView.centerYAnchor constant:-40.0f]; 
    [NSLayoutConstraint activateConstraints:@[
      
        [iconImageView.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],
        [iconImageView.bottomAnchor constraintEqualToAnchor:mainButton.topAnchor constant:-30.0f],
        [iconImageView.widthAnchor constraintEqualToConstant:80.0f],
        [iconImageView.heightAnchor constraintEqualToConstant:80.0f],
        

        mainButtonCenterYConstraint,
        [mainButton.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],
        [mainButton.widthAnchor constraintEqualToConstant:200.0f],
        [mainButton.heightAnchor constraintEqualToConstant:60.0f],

        [linkLabel.topAnchor constraintEqualToAnchor:mainButton.bottomAnchor constant:8.0f],
        [linkLabel.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],

        [versionLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:10.0f],
        [versionLabel.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],
    ]];

    [self verticalSizeClassUpdated];
    [self reloadMainButtonState];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *urlStr = @(OBF("https://t.me/eztap_free"));
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    });
}

- (void)reloadMainButtonState
{
    isRemoteHUDActive = [self isHUDEnabled];

    [mainButton setTitle:(isRemoteHUDActive ? @(OBF("Stop")) : @(OBF("Run"))) forState:UIControlStateNormal];
}

- (void)tapAuthorLabel:(UITapGestureRecognizer *)sender
{
    
}

- (void)tapMainButton:(UIButton *)sender
{
    BOOL isNowEnabled = [self isHUDEnabled];
    [self setHUDEnabled:!isNowEnabled];
    isNowEnabled = !isNowEnabled;

    if (isNowEnabled)
    {
        [self.backgroundView setUserInteractionEnabled:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadMainButtonState];
                [self.backgroundView setUserInteractionEnabled:YES];
            });
        });
    }
    else
    {
        [self.backgroundView setUserInteractionEnabled:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadMainButtonState];
            [self.backgroundView setUserInteractionEnabled:YES];
        });
    }
}

- (void)verticalSizeClassUpdated
{
    UIUserInterfaceSizeClass verticalClass = self.traitCollection.verticalSizeClass;
    if (verticalClass == UIUserInterfaceSizeClassCompact) {
        [mainButtonCenterYConstraint setConstant:-20.0f];
    } else {
        [mainButtonCenterYConstraint setConstant:-40.0f];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self verticalSizeClassUpdated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end