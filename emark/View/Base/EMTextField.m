//
//  EMTextField.m
//
//  Created by neebel on 16/8/25.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "EMTextField.h"

#define padding 5
#define heightSpaceing 2

@interface EMTextField()<UITextFieldDelegate>

//注释
@property (nonatomic,strong) UILabel *placeholderLabel;
//线
@property (nonatomic,strong) UIView *lineView;
//填充线
@property (nonatomic,strong) CALayer *lineLayer;
//移动一次
@property (nonatomic,assign) BOOL moved;

@end


@implementation EMTextField

static const CGFloat lineWidth = 1;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textField = [[UITextField alloc]initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15.f];
        _textField.textColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.tintColor = [UIColor whiteColor];
        [self addSubview:_textField];
        
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:_placeholderLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        
        _lineLayer = [CALayer layer];
        _lineLayer.frame = CGRectMake(0,0, 0, lineWidth);
        _lineLayer.anchorPoint = CGPointMake(0, 0.5);
        _lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [_lineView.layer addSublayer:_lineLayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(obserValue:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_textField];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _placeholderLabel.textColor = _placeholderNormalStateColor ? _placeholderNormalStateColor : [UIColor lightGrayColor];
    _textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-lineWidth);
    _placeholderLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-lineWidth);
    _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-lineWidth, CGRectGetWidth(self.frame), lineWidth);
}


- (void)obserValue:(NSNotification *)obj
{
    [self changeFrameOfPlaceholder];
}


- (void)changeFrameOfPlaceholder
{
    CGFloat y = _placeholderLabel.center.y;
    CGFloat x = _placeholderLabel.center.x;
    if(_textField.text.length != 0 && !_moved){
        [self moveAnimation:x y:y];
    }else if(_textField.text.length == 0 && _moved){
        [self backAnimation:x y:y];
    }
}


- (void)moveAnimation:(CGFloat)x y:(CGFloat)y
{
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = [UIFont systemFontOfSize:10.f];
    _placeholderLabel.textColor = _placeholderSelectStateColor ? _placeholderSelectStateColor : [UIColor whiteColor];

    [UIView animateWithDuration:0.15 animations:^{
        moveY -= _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX -= padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 1;
        _moved = YES;
        _lineLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), lineWidth);
    }];
}


- (void)backAnimation:(CGFloat)x y:(CGFloat)y
{
    __block CGFloat moveX = x;
    __block CGFloat moveY = y;
    _placeholderLabel.font = [UIFont systemFontOfSize:13.f];
    _placeholderLabel.textColor = _placeholderNormalStateColor ? _placeholderNormalStateColor : [UIColor lightGrayColor];

    [UIView animateWithDuration:0.15 animations:^{
        moveY += _placeholderLabel.frame.size.height/2 + heightSpaceing;
        moveX += padding;
        _placeholderLabel.center = CGPointMake(moveX, moveY);
        _placeholderLabel.alpha = 1;
        _moved = NO;
        _lineLayer.bounds = CGRectMake(0, 0, 0, lineWidth);
    }];
}


- (void)setLy_placeholder:(NSString *)ly_placeholder
{
    _ly_placeholder = ly_placeholder;
    _placeholderLabel.text = ly_placeholder;
}


- (void)setCursorColor:(UIColor *)cursorColor
{
    _textField.tintColor = cursorColor;
}

@end
