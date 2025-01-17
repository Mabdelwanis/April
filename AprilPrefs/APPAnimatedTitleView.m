#import "APPAnimatedTitleView.h"


@implementation APPAnimatedTitleView {

	UILabel *_titleLabel;
	NSLayoutConstraint *_yConstraint;
	CGFloat _minimumOffsetRequired;

}


- (instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset {

	if([super init]) {

		_titleLabel = [UILabel new];
		_titleLabel.text = title;
		_titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
		_titleLabel.textColor = UIColor.labelColor;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.clipsToBounds = YES;
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[_titleLabel sizeToFit];

		[self addSubview:_titleLabel];

		[self.widthAnchor constraintEqualToAnchor:_titleLabel.widthAnchor].active = YES;
		[self.heightAnchor constraintEqualToAnchor:_titleLabel.heightAnchor].active = YES;

		[_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
		_yConstraint = [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:100];
		_yConstraint.active = YES;

		_minimumOffsetRequired = minimumOffset;

	}

	return self;

}


- (void)adjustLabelPositionToScrollOffset:(CGFloat)offset {

	CGFloat adjustment = 100 - (offset - _minimumOffsetRequired);

	if(offset > _minimumOffsetRequired) {

		if(adjustment <= 0) _yConstraint.constant = 0; 

		else _yConstraint.constant = adjustment;

	} else _yConstraint.constant = -100;

}


@end
