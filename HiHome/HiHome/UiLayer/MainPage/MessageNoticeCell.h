//
//  MessageNoticeCell.h
//  HiHome
//
//  Created by Rain on 15/10/21.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDetail;
@property (weak, nonatomic) IBOutlet UIButton *mAccept;

@end
