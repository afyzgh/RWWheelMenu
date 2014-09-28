//
//  RWWheelMenu.h
//  RWWheelMenu
//
//  Created by William REN on 9/26/14.
//

#import <UIKit/UIKit.h>

typedef void(^RWWheelMenuItemClickBlock)(int);

@interface RWWheelMenu : UIControl


@property (strong, nonatomic) NSArray *menuButtonImageNames;
@property (strong, nonatomic) NSArray *menuItemTitles;
@property (strong, nonatomic) NSString *backgroundImageName;
@property (strong, nonatomic) RWWheelMenuItemClickBlock menuItemClickBlock;

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)menuItemTitles
       buttonImages:(NSArray *)menuButtonImageNames
    backgroundImage:(NSString *)backgroundImageName
 menuItemClickBlock:(void(^)(int))menuItemClickBlock;


@end
