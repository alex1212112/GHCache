//
//  GHCacheViewController.m
//  GHCache
//
//  Created by Ren Guohua on 14-2-13.
//  Copyright (c) 2014年 ghren. All rights reserved.
//

#import "GHCacheViewController.h"
#import "GHCache.h"


@interface GHCacheViewController ()

@end

@implementation GHCacheViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLabel];
    [self initSaveButton];
    [self initShowButton];
    [self initClearButton];
    [self initTextfield];
    [self addTap];
	
}

- (void)initTextfield
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 80.0f, 300.0f, 44.0f)];
    _textField.background = [UIImage imageNamed:@"text.png"];
    _textField.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_textField];

}

- (void)initLabel
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,150.0f, 300.0f, 44.0f)];
    
    _label.backgroundColor = UIColorFromRGB(0xf1f1f1) ;
    [self.view addSubview:_label];
}

- (void)initSaveButton
{
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(10.0f, 210.0f, 140.0f, 44.0f);
    
    [_saveButton setTitle:@"save" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_saveButton setBackgroundColor:[UIColor redColor]];
    
    [_saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
}
- (void)initShowButton
{
    _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showButton.frame = CGRectMake(170.0f, 210.0f, 140.0f, 44.0f);
    
    [_showButton setTitle:@"read" forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_showButton setBackgroundColor:[UIColor redColor]];
    
    [_showButton addTarget:self action:@selector(showButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showButton];
    
}
- (void)initClearButton
{
    _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showButton.frame = CGRectMake(170.0f, 260.0f, 140.0f, 44.0f);
    
    [_showButton setTitle:@"clear" forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_showButton setBackgroundColor:[UIColor redColor]];
    
    [_showButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showButton];
    
}


- (void)save:(id)sender
{
    if (_textField.text != nil && ![_textField.text isEqualToString:@""])
    {
        NSData *data = [_textField.text dataUsingEncoding:NSUTF8StringEncoding];
        [[GHCache shareCache] cacheData:data tofile:@"data"];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"save success" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert show];
    }
}

- (void)showButtonClicked:(id)sender
{
    NSData *data = [[GHCache shareCache] dataFromFile:@"data"];
    if (data == nil)
    {
        _label.text = @"The cache is empty";
    }
    else
    {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _label.text = string;
    }
}

- (void)clear:(id)sender
{

    [[GHCache shareCache] clearCache];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"clear success" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert show];
}

-(void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)tap:(UIGestureRecognizer *)recognizer
{
    [self makeKeyBoardMiss];
}

-(void)makeKeyBoardMiss
{
    for (id textField in [self.view subviews])
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            UITextField *theTextField = (UITextField*)textField;
            [theTextField resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
