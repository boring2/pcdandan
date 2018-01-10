//
//  TouZhuViewController.m
//  PCDanDan
//
//  Created by xcode.qi on 17/1/17.
//  Copyright © 2017年 li. All rights reserved.
//

#import "TouZhuViewController.h"
#import "TouZhuDXDSCollectionViewCell.h"
#import "DataSource.h"

@interface TouZhuViewController ()<TouZhuDXDSCollectionViewCellDelegate, UITextFieldDelegate>
{
  NSInteger pageNum;
  NSInteger selectDXDSIndex;//大小单双选择投资数字
  NSInteger selectCSZIndex;//猜数字选择投资数字
  NSInteger selectTSWFIndex;//特殊玩法选择投资数字
  UIToolbar *toolbar;
  MBProgressHUD *HUD;
}

@end

@implementation TouZhuViewController
- (void)dealloc
{
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KQuitLogin object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initVariable];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
  //指导页显示
  if ([ShareManager shareInstance].isShowToXZYDY) {
    [self performSelector:@selector(addGuideView) withObject:nil afterDelay:0.5];
  }
  [_moneyText setHidden:true];
  _moneyText.backgroundColor = [UIColor clearColor];
  _moneyText.inputAccessoryView = [self addToolbar];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
  
  [_pageCollectView registerClass:[TouZhuDXDSCollectionViewCell class] forCellWithReuseIdentifier:@"TouZhuDXDSCollectionViewCell"];
  
  //    _leftButton setImageEdgeInsets:
  [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5,5)];
  
  [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5,5)];
  
  _moneyLabel.layer.masksToBounds =YES;
  _moneyLabel.layer.cornerRadius = 3;
  
  _plsmButton.layer.masksToBounds =YES;
  _plsmButton.layer.cornerRadius = 3;
  _plsmButton.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7] CGColor];
  _plsmButton.layer.borderWidth = 1.0f;
  
  _zxtzButton.layer.masksToBounds =YES;
  _zxtzButton.layer.cornerRadius = 3;
  _zxtzButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6];
  
  _sbtzButton.layer.masksToBounds =YES;
  _sbtzButton.layer.cornerRadius = 3;
  _sbtzButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.6];
  
  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  HUD.labelText = @"下注中...";
  [self.view addSubview:HUD];
  
  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(quitLoginDiss)
                                              name:kUpdateUserInfo
                                            object:nil];
  
  GameBiLiListInfo *info = nil;
  if (pageNum == 0) {
    info = [_gameBiLiInfo.da_xiao objectAtIndex:selectDXDSIndex];
  }else if (pageNum == 1) {
    info = [_gameBiLiInfo.shu_zi objectAtIndex:selectCSZIndex];
  }else{
    info = [_gameBiLiInfo.te_shu objectAtIndex:selectTSWFIndex];
  }
  
  if (info.min_point >= 1) {
    _moneyText.placeholder = [NSString stringWithFormat:@"每注最少%.2f元宝",info.min_point];
  }
}

- (void)quitLoginDiss
{
  [self dismissViewControllerAnimated:NO completion:nil];
  [DataSource resetAll];
  [toolbar.items[2] setTitle:@"0.00"];
  _moneyText.text = @"0";
}

#pragma mark - 新手指导页
- (void)addGuideView {
  NSString *imageName = nil;
  if(FullScreen.size.height <= 568)
  {
    imageName = @"tz_1136";
  }else if(FullScreen.size.height == 667)
  {
    imageName = @"tz_1334";
  }else{
    imageName = @"tz_2208";
  }
  
  UIImage *image = [UIImage imageNamed:imageName];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.frame = [UIApplication sharedApplication].keyWindow.frame;
  imageView.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGuideView:)];
  [imageView addGestureRecognizer:tap];
  
  [[UIApplication sharedApplication].keyWindow addSubview:imageView];
}

- (void)dismissGuideView:(UITapGestureRecognizer*)tap
{
  [ShareManager shareInstance].isShowToXZYDY = NO;
  UIImageView *imageview = (UIImageView *)tap.self.view;
  [imageview removeFromSuperview];
}

#pragma mark -http

- (void)putXiaZhuInfoWithIdStr:(NSString *)idStr WithChiceNo:(NSString *)chiceNo
{
  [HUD show:YES];
  HttpHelper *helper = [[HttpHelper alloc] init];
  __weak TouZhuViewController *weakSelf = self;
  [helper putXiaZhuInfoWithRoomId:_roomIDStr
                          user_id:[ShareManager shareInstance].userinfo.id
                        choice_no:chiceNo
                            point:_moneyText.text
                          bili_id:idStr
                          area_id:_areaIDStr
                          success:^(NSDictionary *resultDic){
                            [HUD hide:YES];
                            if ([[resultDic objectForKey:@"result_code"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                            }else
                            {
                              [Tool showPromptContent:[resultDic objectForKey:@"result_desc"] onView:self.view];
                            }
                          }fail:^(NSString *decretion){
                            [HUD hide:YES];
                            [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
  
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
  if([self.delegate respondsToSelector:@selector(touzhuSuccesss)])
  {
    [self.delegate touzhuSuccesss];
  }
  
  [Tool showPromptContent:@"下注成功" onView:self.view];
  [self performSelector:@selector(clickDissButtonAction:) withObject:nil afterDelay:1.5];
}
#pragma mark -  action

- (IBAction)clickDissButtonAction:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
  [DataSource resetAll];
  [toolbar.items[2] setTitle:@"0.00"];
  _moneyText.text = @"0";
}

- (IBAction)clickLeftButtonAction:(id)sender
{
  CGFloat offectSet = _pageCollectView.contentOffset.x;
  if(offectSet == FullScreen.size.width-20)
  {
    [_pageCollectView setContentOffset:CGPointMake(0, _pageCollectView.contentOffset.y) animated:YES];
    pageNum = 0;
    NSLog( @"page=%ld",(long)pageNum);
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [_pageCollectView reloadItemsAtIndexPaths:@[index]];
    
  }else if(offectSet == (FullScreen.size.width-20)*2){
    [_pageCollectView setContentOffset:CGPointMake(FullScreen.size.width-20, _pageCollectView.contentOffset.y) animated:YES];
    pageNum = 1;
    NSLog( @"page=%ld",(long)pageNum);
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    [_pageCollectView reloadItemsAtIndexPaths:@[index]];

  }else{
    return;
  }
  [self upateShowUi];
}
- (IBAction)clickRightButtonAction:(id)sender
{
  CGFloat offectSet = _pageCollectView.contentOffset.x;
  if(offectSet == 0)
  {
    [_pageCollectView setContentOffset:CGPointMake(FullScreen.size.width-20, _pageCollectView.contentOffset.y) animated:YES];
    pageNum = 1;
    NSLog( @"page=%ld",(long)pageNum);
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    [_pageCollectView reloadItemsAtIndexPaths:@[index]];
    
  }else if(offectSet == FullScreen.size.width-20){
    [_pageCollectView setContentOffset:CGPointMake((FullScreen.size.width-20)*2, _pageCollectView.contentOffset.y) animated:YES];
    pageNum = 2;
    NSLog( @"page=%ld",(long)pageNum);
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    [_pageCollectView reloadItemsAtIndexPaths:@[index]];
  }else{
    return;
  }
  
  [self upateShowUi];
}
- (IBAction)clickPLSMButtonAction:(id)sender
{
  SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
  vc.title = @"赔率说明";
  vc.urlStr = [NSString stringWithFormat:@"%@%@%@",URL_Server,Wap_PeiLvShuoMing,_areaIDStr];
  
  UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
  vc.isPresent = YES;
  [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)clickZXTZButtonAction:(id)sender
{
  GameBiLiListInfo *info = nil;
  if (pageNum == 0) {
    info = [_gameBiLiInfo.da_xiao objectAtIndex:selectDXDSIndex];
  }else if (pageNum == 1) {
    info = [_gameBiLiInfo.shu_zi objectAtIndex:selectCSZIndex];
  }else{
    info = [_gameBiLiInfo.te_shu objectAtIndex:selectTSWFIndex];
  }
  _moneyText.text = [NSString stringWithFormat:@"%.0f",info.min_point];
}

- (IBAction)clickSBTZButtonAction:(id)sender
{
  if (_moneyText.text.length < 1) {
    [Tool showPromptContent:@"请输入投注金额" onView:self.view];
  }else{
    _moneyText.text = [NSString stringWithFormat:@"%.0f",[_moneyText.text doubleValue]*2];
  }
}
- (IBAction)clickTZButtonAction:(id)sender
{
  [Tool hideAllKeyboard];
  NSDictionary *dic = nil;
  if([self.delegate respondsToSelector:@selector(getChoiceNoWithstatue)])
  {
    dic = [self.delegate getChoiceNoWithstatue];
  }
  if (!dic) {
    [Tool showPromptContent:@"获取当前游戏信息失败，请稍后再试" onView:self.view];
    return;
  }else{
    int statue = [[dic objectForKey:@"statue"] intValue];
    if (statue == 2)
    {
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"本期已截止" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
      return;
    }else if (statue == 3){
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"停售期间暂不支持投注" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
      return;
    }
  }
  
  GameBiLiListInfo *info = nil;
  if (pageNum == 0) {
    info = [_gameBiLiInfo.da_xiao objectAtIndex:selectDXDSIndex];
  }else if (pageNum == 1) {
    info = [_gameBiLiInfo.shu_zi objectAtIndex:selectCSZIndex];
  }else{
    info = [_gameBiLiInfo.te_shu objectAtIndex:selectTSWFIndex];
  }
  
  if ([_moneyText.text doubleValue] < info.min_point) {
    
    [Tool showPromptContent:[NSString stringWithFormat:@"每注最少%.2f元宝",info.min_point] onView:self.view];
    return;
  }
  if ([_moneyText.text doubleValue] > info.max_point) {
    [Tool showPromptContent:[NSString stringWithFormat:@"每注上限%.2f元宝",info.max_point] onView:self.view];
    return;
  }
  
  if (_gameBiLiInfo) {
    if (_moneyText.text.length < 1) {
      [Tool showPromptContent:@"请输入下注金额" onView:self.view];
      return;
    }
    
    [self putXiaZhuInfoWithIdStr:info.id WithChiceNo:[dic objectForKey:@"chiceNo"]];
  }else{
    [Tool showPromptContent:@"获取下注信息失败，请稍后再试" onView:self.view];
  }
}

#pragma mark - collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return 3;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  TouZhuDXDSCollectionViewCell *cell = (TouZhuDXDSCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TouZhuDXDSCollectionViewCell" forIndexPath:indexPath];
  cell.delegate = self;
  cell.gameBiLiInfo = _gameBiLiInfo;
  cell.showType = indexPath.row;
  
  cell.selectDXDSIndex= selectDXDSIndex;
  cell.selectCSZIndex = selectCSZIndex;
  cell.selectTSWFIndex = selectTSWFIndex;
  [cell updateUI];
  
  
  CGSize size = [cell.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
  cell.titleWidth.constant = size.width;
  
  if (indexPath.row == 0) {
    cell.backgroundColor = RGB(21, 127, 215);
    cell.titleImage.image = PublicImage(@"shouye_125");
    cell.titleLabel.text = @"大小单双";
  }else if (indexPath.row == 1)
  {
    cell.backgroundColor = RGB(226, 75, 78);
    cell.titleImage.image = PublicImage(@"shouye_127");
    cell.titleLabel.text = @"数字特码";
    
  }else{
    cell.backgroundColor = RGB(24, 164, 120);
    cell.titleImage.image = PublicImage(@"shouye_129");
    cell.titleLabel.text = @"特殊玩法";
  }
  
  return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake( collectionView.frame.size.width,collectionView.frame.size.height);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//pagecontrol的点跟着页数改变
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
  [self updateScrollViewOffset];
}

- (void)updateScrollViewOffset
{
  CGPoint offset=_pageCollectView.contentOffset;
  CGRect bounds=_pageCollectView.frame;
  pageNum = offset.x/bounds.size.width;
  
  [self upateShowUi];
}

#pragma mark - TouZhuDXDSCollectionViewCellDelegate
- (void)clickIconWithIndex:(NSInteger )index withParentIndex:(NSInteger)parentIndex
{
  pageNum = parentIndex;
  NSMutableDictionary *dic;
  if (pageNum == 0) {
    selectDXDSIndex = index;
    dic = [DataSource getDxdDataSource][index];
  }else if (pageNum == 1) {
    selectCSZIndex = index;
    dic = [DataSource getCszDataSource][index];
  }else
  {
    selectTSWFIndex = index;
    dic = [DataSource getTswfDataSource][index];
  }
  if ([[dic valueForKey:@"selected"] isEqualToString: @"true"]) {
     [_moneyText becomeFirstResponder];
  } else {
    [_moneyText resignFirstResponder];
  }
  
  [self upateShowUi];
}


- (void)upateShowUi
{
  GameBiLiListInfo *info = nil;
  if (pageNum == 0) {
    info = [_gameBiLiInfo.da_xiao objectAtIndex:selectDXDSIndex];
  }else if (pageNum == 1) {
    info = [_gameBiLiInfo.shu_zi objectAtIndex:selectCSZIndex];
  }else{
    info = [_gameBiLiInfo.te_shu objectAtIndex:selectTSWFIndex];
  }
  _moneyText.text = @"";
  if (info.min_point >= 1) {
    _moneyText.placeholder = [NSString stringWithFormat:@"每注最少%.1f元宝",info.min_point];
  }
}

- (UIToolbar *)addToolbar
{
  toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
  toolbar.backgroundColor = [UIColor grayColor];
  UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *empty = [[UIBarButtonItem alloc] initWithTitle:@"    " style:UIBarButtonItemStylePlain target:nil action:nil];
  UIBarButtonItem *total = [[UIBarButtonItem alloc] initWithTitle:@"0.00" style:UIBarButtonItemStylePlain target:nil action:nil];
  [total setTintColor:[UIColor redColor]];
//  [total setEnabled:NO];
  UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"投注" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
  toolbar.items = @[empty, space, total, space, bar];
  return toolbar;
}

- (void) textFieldDone {
  [_moneyText endEditing:true];
  [_moneyText resignFirstResponder];
  NSMutableDictionary *dataDic;
  NSInteger indexPathForRow;
  if (pageNum == 0) {
    dataDic = [DataSource getDxdDataSource][selectDXDSIndex];
    indexPathForRow = 0;
  } else if (pageNum == 1) {
    dataDic = [DataSource getCszDataSource][selectCSZIndex];
    indexPathForRow = 1;
  } else {
    dataDic = [DataSource getTswfDataSource][selectTSWFIndex];
    indexPathForRow = 2;
  }

  NSDictionary *dic = nil;
  if([self.delegate respondsToSelector:@selector(getChoiceNoWithstatue)])
  {
    dic = [self.delegate getChoiceNoWithstatue];
  }
  GameBiLiListInfo *info = nil;
  if (pageNum == 0) {
    info = [_gameBiLiInfo.da_xiao objectAtIndex:selectDXDSIndex];
  }else if (pageNum == 1) {
    info = [_gameBiLiInfo.shu_zi objectAtIndex:selectCSZIndex];
  }else{
    info = [_gameBiLiInfo.te_shu objectAtIndex:selectTSWFIndex];
  }

  if ([_moneyText.text doubleValue] < info.min_point) {

    [Tool showPromptContent:[NSString stringWithFormat:@"每注最少%.2f元宝",info.min_point] onView:self.view];
    [dataDic setValue:@"false" forKey:@"selected"];
    [_pageCollectView reloadData];
    _moneyText.text = @"0.00";
    [toolbar.items[2] setTitle:@"0.00"];
    return;
  }
  if ([_moneyText.text doubleValue] > info.max_point) {
    [Tool showPromptContent:[NSString stringWithFormat:@"每注上限%.2f元宝",info.max_point] onView:self.view];
    [dataDic setValue:@"false" forKey:@"selected"];
    [_pageCollectView reloadData];
    _moneyText.text = @"0.00";
    [toolbar.items[2] setTitle:@"0.00"];
    return;
  }

  if (_gameBiLiInfo) {
    if ([_moneyText.text isEqualToString: @"0"] || [_moneyText.text isEqualToString: @"0.00"]) {
      [Tool showPromptContent:@"请输入下注金额" onView:self.view];
      [dataDic setValue:@"false" forKey:@"selected"];
      [_pageCollectView reloadData];
      _moneyText.text = @"0.00";
      [toolbar.items[2] setTitle:@"0.00"];
      return;
    }
  }

  NSString *total = _moneyText.text;
  [dataDic setValue:total forKey:@"total"];
  [_pageCollectView reloadData];
  _moneyText.text = @"0.00";
  [toolbar.items[2] setTitle:@"0.00"];
}



// uitextfield delegate
- (void) textFieldDidChange {
  UIBarButtonItem *item = [toolbar.items objectAtIndex:2];
  [item setTitle: [NSString stringWithFormat: @"%@", _moneyText.text]];
  if ([_moneyText.text isEqualToString:@""]) {
    [item setTitle: @"0"];
  }
}
@end
