#import <UIKit/UIKit.h>
#import "GcImagePickerUtils.h"




@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface PSUIPrefsListController : UIViewController
-(void)setImage;
@end


@interface UITableView ()
- (void)setImage;
- (void)setBlur;
@end


@interface PSTableCell : UIView
-(void)applyAlpha;
@end




static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";
static BOOL yes;
static BOOL blur;
static BOOL alpha;
float cellAlpha = 1.0f;
float intensity = 1.0f;




CAGradientLayer *gradient;
UIView *view;



UIImage *image;




static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
    yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	alpha = prefs[@"alphaEnabled"] ? [prefs[@"alphaEnabled"] boolValue] : YES;
	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;

}




%hook UITableView


%new


-(void)setImage {


	if(yes) {

		image = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bImage"];
		UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
		[backgroundImageView setFrame:self.frame];
		self.backgroundView = backgroundImageView;
		loadWithoutAFuckingRespring();

		//[backgroundImageView setClipsToBounds:YES];
        //[backgroundImageView setContentMode: UIViewContentModeScaleAspectFill];


		/*view = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
		[view setClipsToBounds:YES];
   	 	gradient = [CAGradientLayer layer];
    	gradient.frame = view.frame;
    	gradient.startPoint = CGPointMake(0,0); // Lower right to upper left
    	gradient.endPoint = CGPointMake(1,1);
    	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:252.0/255.0 green:176.0/255.0 blue:243.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:145.0/255.0 green:81.0/255.0 blue:230.0/255.0 alpha:1.0] CGColor], nil]; // (id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    	[view.layer addSublayer:gradient];
    	[self setBackgroundView:view];*/

		//loadWithoutAFuckingRespring();

	}

}


%new


-(void)setBlur {


	if(blur) {

		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    	UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    	//always fill the view
		blurEffectView.alpha = intensity;
    	blurEffectView.frame = self.backgroundView.bounds;
    	blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.backgroundView addSubview:blurEffectView];

		
		loadWithoutAFuckingRespring();


	}


	loadWithoutAFuckingRespring();


}





-(void)didMoveToSuperview {


	%orig;
	if(!self.backgroundView)


		[self setImage];
	
		[[NSNotificationCenter defaultCenter] removeObserver:self];
    	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImage) name:@"changeImage" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImage) name:@"disableImage" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBlur) name:@"changeBlur" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBlur) name:@"disableBlur" object:nil];

}


-(void)didMoveToWindow {


	%orig;

	if(yes == YES) {


		[self setImage];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:nil];

	}

	else if(yes == NO) {


		[self setImage];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"disableImage" object:nil];

	}

	if(blur == YES) {

		//[self setBlur];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"changeBlur" object:nil];

	}


	else if(blur == NO) {


		//[self setBlur];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"disableBlur" object:nil];

	}

	


}


%end




%hook PSTableCell


%new


-(void)applyAlpha {


	if (alpha) {

		CGFloat red = 0.0, green = 0.0, blue = 0.0, dAlpha = 0.0;
		[self.backgroundColor getRed:&red green:&green blue:&blue alpha:&dAlpha];
		self.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:cellAlpha];
		loadWithoutAFuckingRespring();

	}

	loadWithoutAFuckingRespring();

}


-(void)didMoveToWindow {


	%orig;
	[self applyAlpha];
	loadWithoutAFuckingRespring();

}


-(void)refreshCellContentsWithSpecifier:(id)arg1 {


	%orig(arg1);
	[self applyAlpha];
	loadWithoutAFuckingRespring();


}


%end




%ctor {

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	alpha = prefs[@"alphaEnabled"] ? [prefs[@"alphaEnabled"] boolValue] : YES;
	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;

}