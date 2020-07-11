//
//  RegisterTableViewCell.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import "RegisterTableViewCell.h"
#import <KRCommonUIComponents/CustomTextField.h>
#import <KRCommonUIComponents/JXLRPopTipView.h>
#import <KRCommonComponents/NSString+UserInfo.h>
#import "UserInfo.h"
#import "CountryCodeModel.h"
#import "CountryCodeSelectView.h"
#import <KRCommonUIComponents/AlertViewHelper.h>
#import <KRNetworkManager/NSString+Shove.h>
#import <KRCommonComponents/Macros.h>
#import <KRNetworkManager/KRRequestManager.h>
#import "Masonry.h"
#import <KRCommonComponents/ColorTools.h>
#import <KRCommonComponents/DAConfig.h>
#import <KRCommonUIComponents/KRProgressHud.h>
#import <KRCommonComponents/KRUtils.h>
#import <KRCommonComponents/FontTools.h>


@interface RegisterTableViewCell()
@property (nonatomic, strong) JXLRPopTipView *tipView;
@property (nonatomic, strong) NSMutableArray  *countryArr;
@property (nonatomic, strong) CountryCodeModel  *selectModel;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UILabel *readyLab;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) int verifyTpye;
@property (nonatomic, assign) int inviteCodeStatus;
@end

#define RegisterTableViewCellWidthWind  MSWIDTH - 20
#define COUNT_DONW_NUMBER  60
#define VERIFYTYPE_GET  0
#define VERIFYTYPE_VERIFY  1
@implementation RegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createView];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor systemGroupedBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)initData {
    self.countryArr = [NSMutableArray array];
    CountryCodeModel *model1 = [CountryCodeModel codeModelWithCode:@"86" icon:@"flag_cn" country:@"China"];
    CountryCodeModel *model2 = [CountryCodeModel codeModelWithCode:@"62" icon:@"flag_id" country:@"Indonesia"];
    CountryCodeModel *model3 = [CountryCodeModel codeModelWithCode:@"852" icon:@"flag_hk" country:@"Hong Kong"];
    CountryCodeModel *model4 = [CountryCodeModel codeModelWithCode:@"886" icon:@"flag_tw" country:@"Taiwan"];
    CountryCodeModel *model5 = [CountryCodeModel codeModelWithCode:@"65" icon:@"flag_sg" country:@"Singapore"];
    CountryCodeModel *model6 = [CountryCodeModel codeModelWithCode:@"60" icon:@"flag_my" country:@"Malaysia"];
    CountryCodeModel *model7 = [CountryCodeModel codeModelWithCode:@"66" icon:@"flag_th" country:@"Thailand"];
    CountryCodeModel *model8 = [CountryCodeModel codeModelWithCode:@"84" icon:@"flag_vn" country:@"Vietnam"];
    CountryCodeModel *model9 = [CountryCodeModel codeModelWithCode:@"1" icon:@"flag_us" country:@"United States"];
    [self.countryArr addObject:model1 ];
    [self.countryArr addObject:model2 ];
    [self.countryArr addObject:model3 ];
    [self.countryArr addObject:model4 ];
    [self.countryArr addObject:model5 ];
    [self.countryArr addObject:model6 ];
    [self.countryArr addObject:model7 ];
    [self.countryArr addObject:model8 ];
    [self.countryArr addObject:model9 ];
    
    self.verifyTpye = VERIFYTYPE_GET;
    
}

- (void)createView {
    // 用户名的边框
    
    // 请输入手机号
    _phoneWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 30, RegisterTableViewCellWidthWind, 55)];
    [_phoneWindow setWidthLeftImage:@"flag_cn" rightImage:@"Right_error" placeName:NSLocalizedString(@"please_input_phone", nil)];
    KRWeakSelf(self);
    _phoneWindow.tapleftActionBlock = ^{
        KRStrongSelf(self);
        [self showCodeView];
    };
    
    _phoneWindow.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _phoneWindow.delegate = self;
    _phoneWindow.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneWindow.rightBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_phoneWindow];
    
    
    self.bgView.frame = CGRectMake(10, 96, RegisterTableViewCellWidthWind, 55);
    [self.contentView addSubview:self.bgView];
    
    
    self.readyLab.frame = CGRectMake(16, 5, RegisterTableViewCellWidthWind - 32, 21);
    self.readyLab.hidden = YES;
    [self.bgView addSubview:self.readyLab];
    // 请输入验证码
    _verifyWindow = [[CustomTextField alloc] initWithFrame:CGRectMake(10, 96, RegisterTableViewCellWidthWind, 55)];
    [_verifyWindow setWidthLeftImage:@"Find_code" rightImage:nil placeName:NSLocalizedString(@"tv_verify_code_hint", nil)];
    _verifyWindow.delegate = self;
    _verifyWindow.keyboardAppearance = UIKeyboardTypeNumbersAndPunctuation;
    _verifyWindow.returnKeyType = UIReturnKeyNext;
    [self.contentView addSubview:_verifyWindow];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
     [self.contentView addSubview:_verifyBtn];
    [_verifyBtn setContentCompressionResistancePriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    [_verifyBtn.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisHorizontal];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.equalTo(self.contentView).offset(106);
//        make.width.mas_equalTo(40);
        make.height.mas_equalTo(35);
    }];
    _verifyBtn.backgroundColor = KRedColor;
    _verifyBtn.layer.cornerRadius = 3.0;
    _verifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_verifyBtn setTitle:NSLocalizedString(@"tv_get_code", nil) forState:UIControlStateNormal];
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_verifyBtn];
    
    //放大提示
    //    _reminderView = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_phoneWindow.frame), MSWIDTH-10, 0)];
    
    
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(10, CGRectGetMaxY(_verifyWindow.frame) + 10, RegisterTableViewCellWidthWind, 50);
    self.nextBtn.backgroundColor = KRedColor;
    self.nextBtn.layer.cornerRadius = 3.0;
    self.nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.nextBtn setTitle:NSLocalizedString(@"tv_next", nil) forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nextBtn];
    
}

#pragma mark - 验证按钮
- (void)verifyBtnClick
{
    if (![self checkphoneStypisRight]) {
        return;
    }
    
    [self p_updateMaskBeforeButtonTouch];
    
    //    if ([self.phone isPhone]) {
    DLOG(@"phone is right");
    __block int timeout = COUNT_DONW_NUMBER; //倒计时时间
   KRWeakSelf(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                KRStrongSelf(self);
                [self.verifyBtn setTitle:NSLocalizedString(@"tv_resend_code", nil) forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
                [self.verifyBtn setAlpha:1];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                KRStrongSelf(self);
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"tv_resend_code", nil),strTime] forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = NO;
                [self.verifyBtn setAlpha:0.4];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    [self getVerification:nil];
}

#pragma mark   获取验证码
-(void) getVerification:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[[DAConfig userLanguage] substringToIndex:2] forKey:@"language"];
    [parameters setObject:[NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text] forKey:@"cellPhone"];
    
    [KRRequestManager sendRequestWithRequestMethodType:RequestGET requestAPICode:@"app/services" requestParameters:parameters requestHeader:nil success:^(id  _Nonnull responseObject) {
        
    } faild:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark   获取验证码
-(void) checkVerification:(UIButton *)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[[DAConfig userLanguage] substringToIndex:2] forKey:@"language"];
    [parameters setObject:[NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text] forKey:@"cellPhone"];
    [parameters setObject:_verifyWindow.text forKey:@"randomCode"];
    
    [KRRequestManager sendRequestWithRequestMethodType:RequestGET requestAPICode:@"app/services" requestParameters:parameters requestHeader:nil success:^(id  _Nonnull responseObject) {
        NSDictionary *dics = responseObject;
        if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
               if (self.verifyTpye == VERIFYTYPE_GET) {
                   [KRProgressHud show:(KRLANGGECE(@"verify_code_send_to"))];
                   self.inviteCodeStatus = [dics [@"inviteCodeStatus"] intValue];
                   return;
               }
           }else {
               DLOG(@"返回失败  msg -> %@",[dics objectForKey:@"msg"]);
               
               [KRProgressHud showErrorWithStatus:[dics objectForKey:@"msg"]];
           }
    } faild:^(NSError * _Nonnull error) {
        [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_request_failed", nil)];
    }];
}


#pragma mark - 下一步
- (void)nextBtnClick
{
    if ( [_verifyWindow isEditing]) {
        [_verifyWindow resignFirstResponder];
    }
    if (![self checkphoneStypisRight]) {
        return;
    }
    
    // 如果验证码为空
    if (_verifyWindow.text.length == 0) {
        [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
        self.tipView.titleLbl1.text = NSLocalizedString(@"tips_input_verify_code", nil);
        [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
        [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.tipView];
        return;
    }
    // 设置为校验验证码
    self.verifyTpye = VERIFYTYPE_VERIFY;
    [self requestData];
}


- (BOOL)checkphoneStypisRight {
    if ( [_phoneWindow isEditing]) {
        [_phoneWindow resignFirstResponder];
    }
    
    self.tipView  = [[JXLRPopTipView alloc] initWithFrame:CGRectMake(0, 0, MSWIDTH, self.superview.frame.size.height)];
    
    if (_phoneWindow.text.length == 0) {
    
        [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
        self.tipView.titleLbl1.text = KRLANGGECE(@"login_err_phone_empty");
        [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
        [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.tipView];
        return NO;
    }
    
    if ([self.selectModel.code isEqualToString:@"86"]) { // 中国
        if (![_phoneWindow.text isPhone] ) {
            [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
            self.tipView.titleLbl1.text = KRLANGGECE(@"tips_phone_format_incorrect");
            [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
            [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.tipView];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"62"]) {// 印尼
        if (self.phoneWindow.text.length != 10) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"852"]) {// 香港
        if (self.phoneWindow.text.length != 8) {
            [self showTip];
            return NO;
        }
        
    }else if ([self.selectModel.code isEqualToString:@"886"]) {// 台湾
        if (self.phoneWindow.text.length != 10) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"65"]) { // 新加坡
        if (self.phoneWindow.text.length != 8) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"60"]) { // 马来西亚
        if (self.phoneWindow.text.length != 7) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"66"]) { // 泰国
        if (self.phoneWindow.text.length != 10) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"84"]) { // 越南
        if (!((self.phoneWindow.text.length == 10) || (self.phoneWindow.text.length == 11))) {
            [self showTip];
            return NO;
        }
    }else if ([self.selectModel.code isEqualToString:@"1"]) { // 美国
        if (self.phoneWindow.text.length != 10) {
            [self showTip];
            return NO;
        }
    }
    if (![_phoneWindow.text isPhone] && [self.selectModel.code isEqualToString:@"86"] ) {
        [self showTip];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideEnterKeyboard];
}


- (void)hideEnterKeyboard {
    for (UITextField *textField in [self.contentView subviews]) {
        if ([textField isKindOfClass: [UITextField class]]) {
            
            [textField  resignFirstResponder];
        }
    }
    
}

- (void)showTip {
    [self hideEnterKeyboard];
    [self.tipView.topBtn setTitle:NSLocalizedString(@"title_tips", nil) forState:UIControlStateNormal];
    self.tipView.titleLbl1.text = NSLocalizedString(@"tips_phone_format_incorrect", nil);
    [self.tipView.bottomBtn setTitle:NSLocalizedString(@"dialog_sure", nil) forState:UIControlStateNormal];
    [self.tipView.bottomBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.tipView];
    return;
}

- (void)showCodeView {
    [self hideEnterKeyboard];
    [self initData];
    KRWeakSelf(self);
//    [AlertViewHelper alertCountryCodeSelectView:self.countryArr confirm:^(CountryCodeModel * _Nonnull model) {
//        KRStrongSelf(self);
//        self.selectModel = model;
//        self.phoneWindow.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",model.icon]];
//    }];
}


#pragma mark - uitextfield
//设置文本框只能输入数字

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //如果是限制只能输入数字的文本框
    if (_phoneWindow == textField) {
        return [KRUtils validateNumber:string];
    }
    return YES;
    
}

#pragma mark - 请求数据
- (void)requestData {
    //暂时先用登录接口，后面要新增判断账号是否存在接口
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"4" forKey:@"OPT"];
    [parameters setObject:@"" forKey:@"body"];
    [parameters setObject:[[DAConfig userLanguage] substringToIndex:2] forKey:@"language"];
    [parameters setObject:[NSString stringWithFormat:@"%@%@",self.selectModel.code, _phoneWindow.text] forKey:@"cellPhone"];
    [parameters setObject:@"0" forKey:@"verify"];
    [parameters setObject:_verifyWindow.text forKey:@"randomCode"];
    
    [KRRequestManager sendRequestWithRequestMethodType:RequestGET requestAPICode:@"app/services" requestParameters:parameters requestHeader:nil success:^(id  _Nonnull responseObject) {
            NSDictionary *dics = responseObject;
            if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
                   UserInfo *usermodel = [[UserInfo alloc] init];
                   usermodel.userName = _phoneWindow.text;
                   usermodel.cellPhone = [NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text];
    //               AppDelegateInstance.userInfo = usermodel;
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                dict[@"phone"] = [NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text];
                dict[@"name"] = _phoneWindow.text;
                dict[@"verifyCode"] = _verifyWindow.text;
                dict[@"inviteCodeStatus"] = dics [@"inviteCodeStatus"];
                   if (self.nextBlock) {
                       self.nextBlock(dict);
                   }
               }else {
                   DLOG(@"返回失败  msg -> %@",[dics objectForKey:@"msg"]);
                   
                   [KRProgressHud showErrorWithStatus:[dics objectForKey:@"msg"]];
               }
        } faild:^(NSError * _Nonnull error) {
            [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_request_failed", nil)];
        }];
}


#pragma mark  HTTPClientDelegate 网络数据回调代理
//-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj {
//    NSDictionary *dics = obj;
//
//    if ([[NSString stringWithFormat:@"%@",[dics objectForKey:@"error"]] isEqualToString:@"-1"]) {
//        if (self.verifyTpye == VERIFYTYPE_GET) {
//            HUD_SUCCESS(KRLANGGECE(@"verify_code_send_to"));
//            self.inviteCodeStatus = [dics [@"inviteCodeStatus"] intValue];
//            return;
//        }
//        UserInfo *usermodel = [[UserInfo alloc] init];
//        usermodel.userName = _phoneWindow.text;
//        usermodel.cellPhone = [NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text];
//        AppDelegateInstance.userInfo = usermodel;
//
//        RegNextViewController *vc = [[RegNextViewController alloc] init];
//        vc.phone = [NSString stringWithFormat:@"%@%@", self.selectModel.code, _phoneWindow.text];
//        vc.name = _phoneWindow.text;
//        vc.verifyCode = _verifyWindow.text;
//        vc.inviteCodeStatus = [dics [@"inviteCodeStatus"] intValue];
//        [self.deleagate.navigationController pushViewController:vc animated:YES];
//
//    }else {
//        DLOG(@"返回失败  msg -> %@",[obj objectForKey:@"msg"]);
//
//        [KRProgressHud showErrorWithStatus:[obj objectForKey:@"msg"]];
//    }
//}


//// 返回失败
//-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error {
//    // 服务器返回数据异常
//    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_request_failed", nil)];
//}

// 无可用的网络
-(void) networkError {
    [KRProgressHud showErrorWithStatus:NSLocalizedString(@"toast_check_network", nil)];
}




#pragma mark - acitons
- (void)sureBtnClick
{
    if ([self.tipView.bottomBtn.titleLabel.text isEqualToString:NSLocalizedString(@"dialog_sure", nil)]) {
        [self.tipView removeFromSuperview];
    }
}


- (void)clearText
{
    if (_phoneWindow.text.length != 0) {
        _phoneWindow.text = @"";
    }
    
}



#pragma mark - private method
- (void)p_updateMaskBeforeButtonTouch {
    self.readyLab.text = [NSString stringWithFormat:NSLocalizedString(@"verify_code_send_to_phone", nil),self.selectModel.code,self.phoneWindow.text];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect bgframe = self.bgView.frame;
        bgframe.size.height = 55 + 25;
        self.bgView.frame = bgframe;
        self.readyLab.hidden = NO;
        
        CGRect vfframe = self.verifyWindow.frame;
        vfframe.origin.y = 96 + 25;
        self.verifyWindow.frame = vfframe;
        
        CGRect nextFrame = self.nextBtn.frame;
        nextFrame.origin.y = CGRectGetMaxY(self.bgView.frame) + 10;
        self.nextBtn.frame = nextFrame;
        [self.verifyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.top.equalTo(self.contentView).offset(106 + 25);
            make.height.mas_equalTo(35);
        }];
        
    } completion:nil];
    
}



#pragma mark - setter/getter

- (CountryCodeModel *)selectModel {
    if (!_selectModel) {
        _selectModel = [CountryCodeModel codeModelWithCode:@"86" icon:@"flag_cn" country:@"China"];
    }
    return _selectModel;
}

- (UILabel *)readyLab {
    if (!_readyLab) {
        _readyLab = [KRUtils creatLabelWithTitleColor:KBlackColor font:KRFont(12) textAlignment:(NSTextAlignmentLeft)];
    }
    return _readyLab;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = KWhitekColor;
    }
    return _bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
