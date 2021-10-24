// Credits for the implementation of the changelog controller:
// https://github.com/nahtedetihw
// https://github.com/nahtedetihw/MusicBackground


#include "APRRootListController.h"


static NSString *const plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";


#define tint [UIColor colorWithRed: 1.00 green: 0.55 blue: 0.73 alpha: 1.00]


static void postNSNotification() {

	[NSNotificationCenter.defaultCenter postNotificationName:@"applyImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyGradient" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyScheduledImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyBlur" object:NULL];

}


@implementation APRRootListController


- (NSArray *)specifiers {

	if(!_specifiers) {
		
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
		NSArray *chosenIDs = @[@"GroupCell-1", @"Image", @"LightImage", @"SegmentCell", @"BlurValue", @"AlphaValue", @"GroupCell-5", @"AnimateGradientSwitch", @"FirstColor", @"SecondColor", @"GroupCell-6", @"GroupCell-7", @"GradientDirection", @"GroupCell8", @"MorningImage", @"AfternoonImage", @"SunsetImage", @"MidnightImage"];
		
		self.savedSpecifiers = (self.savedSpecifiers) ?: [NSMutableDictionary new];
		
		for(PSSpecifier *specifier in _specifiers)
			
			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])
				
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"YesSwitch"]] boolValue]) {

		[self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"Image"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:NO];

	}


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-1"]]) {

		[self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];

	}


	if (![[self readPreferenceValue:[self specifierForID:@"BlurSwitch"]] boolValue]) {

		[self removeSpecifier:self.savedSpecifiers[@"SegmentCell"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"BlurValue"] animated:NO];

	}


	else if(![self containsSpecifier:self.savedSpecifiers[@"SegmentCell"]]) {

		[self insertSpecifier:self.savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:NO];

	}


	if(![[self readPreferenceValue:[self specifierForID:@"AlphaSwitch"]] boolValue])

		[self removeSpecifier:self.savedSpecifiers[@"AlphaValue"] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"AlphaValue"]])

		[self insertSpecifier:self.savedSpecifiers[@"AlphaValue"] afterSpecifierID:@"AlphaSwitch" animated:NO];


	if(![[self readPreferenceValue:[self specifierForID:@"GradientSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:NO];



	if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"MorningImage"], self.savedSpecifiers[@"AfternoonImage"], self.savedSpecifiers[@"SunsetImage"], self.savedSpecifiers[@"MidnightImage"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell8"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"MorningImage"], self.savedSpecifiers[@"AfternoonImage"], self.savedSpecifiers[@"SunsetImage"], self.savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:NO];

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/imageChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/gradientChanged"), NULL, 0);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)postNSNotification, CFSTR("me.luki.aprilprefs/scheduledImageChanged"), NULL, 0);

	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/Assets/AprilBanner.png"];

	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	self.headerImageView = [UIImageView new];
	self.headerImageView.image = banner;
	self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.headerView addSubview:self.headerImageView];

	UIButton *changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	changelogButton.tintColor = tint;
	changelogButton.layer.masksToBounds = YES;
	[changelogButton setImage : [UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
	[changelogButton addTarget : self action:@selector(showWtfChangedInThisVersion:) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];

	self.navigationItem.rightBarButtonItem = changelogButtonItem;

	[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor].active = YES;
	[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor].active = YES;
	[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor].active = YES;
	[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor].active = YES;

	_table.tableHeaderView = self.headerView;

}


- (void)showWtfChangedInThisVersion:(id)sender {

	AudioServicesPlaySystemSound(1521);

	self.changelogController = [[OBWelcomeController alloc] initWithTitle:@"April" detailText:@"2.0.1" icon:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/AprilPrefs.bundle/Assets/AprilIcon.png"]];

	[self.changelogController addBulletedListItemWithTitle:@"Code" description:@"Refactoring." image:[UIImage systemImageNamed:@"checkmark.circle.fill"]];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor : self.changelogController.viewIfLoaded.trailingAnchor].active = YES;

	self.changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;
	self.changelogController.view.tintColor = tint;
	self.changelogController.modalInPresentation = NO;
	self.changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentViewController:self.changelogController animated:YES completion:nil];

}


- (void)dismissVC {

	[self.changelogController dismissViewControllerAnimated:YES completion:nil];

}


- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

	if(!self.navigationItem.titleView) {

		APPAnimatedTitleView *titleView = [[APPAnimatedTitleView alloc] initWithTitle:@"April 2.0.1" minimumScrollOffsetRequired:-68];

		self.navigationItem.titleView = titleView;
		self.titleView.superview.clipsToBounds = YES;

	}

}


- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	CGRect frame = self.table.bounds;
	frame.origin.y = -frame.size.height;

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	CGFloat offsetY = scrollView.contentOffset.y;

	if(offsetY > 0) offsetY = 0;
	self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);

	if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)])

		[(APPAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


- (id)readPreferenceValue:(PSSpecifier*)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:plistPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:plistPath atomically:YES];

	[NSNotificationCenter.defaultCenter postNotificationName:@"applyImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyAlpha" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyGradient" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyScheduledImage" object:NULL];
	[NSNotificationCenter.defaultCenter postNotificationName:@"applyBlur" object:NULL];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"yes"]) {

		if(![value boolValue]) {

			[self removeSpecifier:self.savedSpecifiers[@"GroupCell-1"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"Image"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"LightImage"] animated:NO];

		}

		else if(![self containsSpecifier:self.savedSpecifiers[@"Image"]]) {

			[self insertSpecifier:self.savedSpecifiers[@"GroupCell-1"] afterSpecifierID:@"YesSwitch" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"Image"] afterSpecifierID:@"GroupCell-1" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"LightImage"] afterSpecifierID:@"Image" animated:NO];

		}

	}

	if([key isEqualToString:@"blur"]) {

		if(![value boolValue]) {

			[self removeSpecifier:self.savedSpecifiers[@"SegmentCell"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"BlurValue"] animated:YES];

		}

		else if(![self containsSpecifier:self.savedSpecifiers[@"BlurValue"]]) {

			[self insertSpecifier:self.savedSpecifiers[@"SegmentCell"] afterSpecifierID:@"BlurSwitch" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"BlurValue"] afterSpecifierID:@"SegmentCell" animated:YES];

		}

	}

	if([key isEqualToString:@"alphaEnabled"]) {

		if(![value boolValue])

			[self removeSpecifier:self.savedSpecifiers[@"AlphaValue"] animated:YES];

		else if (![self containsSpecifier:self.savedSpecifiers[@"AlphaValue"]])

			[self insertSpecifier:self.savedSpecifiers[@"AlphaValue"] afterSpecifierID:@"AlphaSwitch" animated:YES];

	}

	if([key isEqualToString:@"setGradientAsBackground"]) {

		if(![value boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] animated:YES];

		else if (![self containsSpecifier:self.savedSpecifiers[@"GroupCell-5"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell-5"], self.savedSpecifiers[@"AnimateGradientSwitch"], self.savedSpecifiers[@"GroupCell-6"], self.savedSpecifiers[@"FirstColor"], self.savedSpecifiers[@"SecondColor"], self.savedSpecifiers[@"GroupCell-7"], self.savedSpecifiers[@"GradientDirection"]] afterSpecifierID:@"GradientSwitch" animated:YES];

	}

	if([key isEqualToString:@"scheduledImages"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"ScheduledImagesSwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"MorningImage"], self.savedSpecifiers[@"AfternoonImage"], self.savedSpecifiers[@"SunsetImage"], self.savedSpecifiers[@"MidnightImage"]] animated:YES];


		else if(![self containsSpecifier:self.savedSpecifiers[@"GroupCell8"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"GroupCell8"], self.savedSpecifiers[@"MorningImage"], self.savedSpecifiers[@"AfternoonImage"], self.savedSpecifiers[@"SunsetImage"], self.savedSpecifiers[@"MidnightImage"]] afterSpecifierID:@"ScheduledImagesSwitch" animated:YES];    

	}

}


- (void)gradientPresets {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://digitalsynopsis.com/design/beautiful-gradient-color-palettes/"] options:@{} completionHandler:nil];

}


- (void)shatterThePrefsToPieces {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"April"
	message:@"Do you want to start fresh?"
	preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		BOOL success = [fileM removeItemAtPath:@"var/mobile/Library/Preferences/me.luki.aprilprefs.plist" error:nil];
		BOOL successTwo = [fileM removeItemAtPath:@"var/mobile/Library/Preferences/me.luki.aprilprefs" error:nil];

		if((success) || (successTwo)) {

			[self blurEffect];

		}

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Meh" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}

- (void)blurEffect {

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	backdropView.alpha = 0;
	backdropView.frame = self.view.bounds;
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	[self.view addSubview:backdropView];

	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		backdropView.alpha = 1;

	} completion:^(BOOL finished) {

		[self killSettings];

	}];

}

- (void)killSettings {

	pid_t pid;
	const char* args[] = {"killall", "Preferences", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

}


@end


@implementation AprilContributorsRootListController


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AprilContributors" target:self];

	return _specifiers;

}


@end




@implementation AprilLinksRootListController


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"AprilLinks" target:self];

	return _specifiers;

}


- (void)discord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)paypal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)github {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/April"] options:@{} completionHandler:nil];

}


- (void)amelija {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/me.luki.amelija"] options:@{} completionHandler:nil];

}


- (void)meredith {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.meredith"] options:@{} completionHandler:nil];

}


@end


@implementation AprilTableCell


- (void)tintColorDidChange {

	[super tintColorDidChange];

	self.textLabel.textColor = tint;
	self.textLabel.highlightedTextColor = tint;

}


- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {

	[super refreshCellContentsWithSpecifier:specifier];

	if([self respondsToSelector:@selector(tintColor)]) {

		self.textLabel.textColor = tint;
		self.textLabel.highlightedTextColor = tint;

	}

}


@end
