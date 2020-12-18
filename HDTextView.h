//
//  HDTextView.h
//  zykTools
//
//  Created by ZYK on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HDTextView;
@interface HDTextView : UITextView<UITextViewDelegate>

@property (strong, nonatomic) UILabel *placeholderLabel;//占位label
@property (copy, nonatomic) NSString *placeholder; //占位字
@property (assign, nonatomic) NSInteger maxLength;//最大长度
@property (strong, nonatomic) UILabel *wordNumLabel;//计算字数label
///是否允许输入emoji 默认不允许
@property (nonatomic, assign) BOOL allowEmoji;

///文字输入
@property (copy, nonatomic) void(^didChangeText)(HDTextView *textView);

- (void)didChangeText:(void(^)(HDTextView *textView))block;

@end

NS_ASSUME_NONNULL_END
