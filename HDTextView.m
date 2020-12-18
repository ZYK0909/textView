//
//  HDTextView.m
//  zykTools
//
//  Created by ZYK on 2020/12/3.
//

#import "HDTextView.h"
@interface HDTextView()
@property (strong, nonatomic) NSString *currentText;

@end
@implementation HDTextView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self setView];
        //设置文字偏移量
        self.textContainerInset = UIEdgeInsetsMake(16, 15, 16, 15);
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self addObserver];
        [self setView];
        //设置文字偏移量
        self.textContainerInset = UIEdgeInsetsMake(16, 15, 16, 15);
        
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        [self addObserver];
        [self setView];
        //设置文字偏移量
        self.textContainerInset = UIEdgeInsetsMake(16, 15, 16, 15);
    }
    return self;
}
-(void)setView{
    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, self.frame.size.width-16, self.frame.size.height)];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [self font];
        [self addSubview:self.placeholderLabel];
        super.delegate = self;
    }
    
    if (!self.wordNumLabel) {
        
        self.wordNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.wordNumLabel.font = [UIFont systemFontOfSize:13];
        self.wordNumLabel.textColor = [UIColor lightGrayColor];
        self.wordNumLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.wordNumLabel];
        
        
    }
    
    self.allowEmoji = NO;//不允许输入emoji
    
}

-(void)layoutSubviews{
    self.placeholderLabel.frame = CGRectMake(16, 16, self.frame.size.width-16, self.frame.size.height);
    [self.placeholderLabel sizeToFit];
    [self.wordNumLabel sizeToFit];
    [self refreshFram];
}
-(void)addObserver
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeholderTextViewdidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    
    
}


-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFit];
    [self endEditing:NO];
}
-(void)setMaxLength:(NSInteger)maxLength{
    
    _maxLength = maxLength;
    self.wordNumLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
    
}
-(void)placeholderTextViewdidChange:(NSNotification *)notificat{
    
    HDTextView *textView = (HDTextView *)notificat.object;
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
        
    }
    
    if ([textView.text length]>self.maxLength&&self.maxLength!=0&&textView.markedTextRange == nil) {
        
        
        textView.text = [textView.text substringToIndex:self.maxLength];
        
    }
    self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[textView.text length],(long)_maxLength];
    if (self.didChangeText) {
        self.didChangeText(textView);
    }
    
    [self refreshFram];
    _currentText = textView.text;
    
}


- (void)didChangeText:(void (^)(HDTextView *))block{
    self.didChangeText = block;
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length>0) {
        [self.placeholderLabel setHidden:YES];
        self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[text length],(long)_maxLength];
        [self.wordNumLabel sizeToFit];
        [self refreshFram];
        
    }
}


-(void)placeholderTextViewEndEditing{
    
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
        
    }
}

- (void)refreshFram{
    [self.wordNumLabel sizeToFit];
    if (self.contentSize.height>self.frame.size.height-self.wordNumLabel.frame.size.height-5) {
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.contentSize.height+self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, self.wordNumLabel.frame.size.height, 0);
        
    }else{
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.frame.size.height + self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//判断是否输入的是emoji表情
- (BOOL)stringContainsEmoji:(NSString *)string{
    NSUInteger stringUtf8Length = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if(stringUtf8Length >= 4 && (stringUtf8Length / string.length != 3)){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.allowEmoji) {
        return YES;
    }else {
    if ([self stringContainsEmoji:text]) {
        NSLog(@"输入的是表情...");
        return NO;
    }else{
        NSLog(@"输入的不是表情...");
        return YES;
    }
    }
}


@end
