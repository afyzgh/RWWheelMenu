//
//  RWWheelMenu.m
//  RWWheelMenu
//
//  Created by William REN on 9/26/14.
//

#import "RWWheelMenu.h"
#import "RWWheelMenuItem.h"

@interface RWWheelMenu() {
@private
    UIButton *_menuButton;
    NSMutableArray *_menuTitleLabels;
    NSMutableArray *_menuItems;
    UIView *_contentView;
    NSInteger _count;
    NSInteger _currentIndex;
    CGAffineTransform _transform;
    BOOL viewLoaded;
}

@end

static float deltaAngle;

@implementation RWWheelMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initMenu];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)menuItemTitles
            buttonImages:(NSArray *)menuButtonImageNames
    backgroundImage:(NSString *)backgroundImageName
 menuItemClickBlock:(void(^)(int))menuItemClickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.menuItemClickBlock = menuItemClickBlock;
        self.backgroundImageName = backgroundImageName;
        self.menuItemTitles = menuItemTitles;
        _count = _menuItemTitles.count;
        self.menuButtonImageNames = menuButtonImageNames;
        [self initMenu];
    }
    return self;
}

- (void)initMenu {
    
    if (viewLoaded) {
        return;
    }

    if (_menuItemTitles.count == 0) {
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:self.bounds];
        errorLabel.backgroundColor = [UIColor whiteColor];
        errorLabel.textColor = [UIColor redColor];
        errorLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        errorLabel.numberOfLines = 0;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.text = @"ARE YOU KIDDING ME? NO ITEMS?";
        [self addSubview:errorLabel];
        return;
    }
    
    if (_menuButtonImageNames.count > 0 &&
        _menuItemTitles.count != _menuButtonImageNames.count) {
        
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:self.bounds];
        errorLabel.backgroundColor = [UIColor whiteColor];
        errorLabel.textColor = [UIColor redColor];
        errorLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        errorLabel.numberOfLines = 0;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.text = @"ARE YOU KIDDING ME? YOU MUST KIDDING ME!";
        [self addSubview:errorLabel];
        return;
    }
    
    _menuTitleLabels = [NSMutableArray array];
    _menuItems = [NSMutableArray array];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:_backgroundImageName];
    [self addSubview:backgroundImageView];
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    
    CGFloat angleSize = 2 * M_PI / _count;
    
    for (int i = 0; i < _count; i++) {
        
        float menuItemHeight = self.bounds.size.height / 2;
        float menuItemWidth = sqrt(menuItemHeight * menuItemHeight + menuItemHeight * menuItemHeight - 2 * cos(angleSize) * menuItemHeight * menuItemHeight);
        UIView *menuItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuItemWidth, menuItemHeight)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(menuItemWidth / _count, menuItemHeight / 7, menuItemWidth - 2 * (menuItemWidth / _count), 13)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = _menuItemTitles[i];
        menuItemView.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
        menuItemView.layer.position = CGPointMake(menuItemHeight, menuItemHeight);
        menuItemView.transform = CGAffineTransformMakeRotation(angleSize * i);
        [menuItemView addSubview:titleLabel];
        [_menuTitleLabels addObject:titleLabel];
        [_contentView addSubview:menuItemView];
        
    }
    
    _contentView.userInteractionEnabled = NO;
    [self addSubview:_contentView];
    if (_menuButtonImageNames.count > 0) {
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake((self.bounds.size.width - 114) / 2, (self.bounds.size.height - 114) / 2, 114, 114);
        _menuButton.tag = 100;
        [self addSubview:_menuButton];
    }
    
    if (_count % 2 == 0) {
        
        [self createEvenItems];
        
    } else {
        
        [self createOddItems];
        
    }
    
    [self menuItemDidChange:_currentIndex];
    
    viewLoaded = true;
    
}

- (void)createEvenItems {
    
    CGFloat fanWidth = M_PI*2/_count;
    CGFloat mid = 0;
    
    for (int i = 0; i < _count; i++) {
        
        RWWheelMenuItem *menuItem = [[RWWheelMenuItem alloc] init];
        menuItem.midValue = mid;
        menuItem.minValue = mid - (fanWidth/2);
        menuItem.maxValue = mid + (fanWidth/2);
        menuItem.value = i;
        
        
        if (menuItem.maxValue-fanWidth < - M_PI) {
            
            mid = M_PI;
            menuItem.midValue = mid;
            menuItem.minValue = fabsf(menuItem.maxValue);
            
        }
        
        mid -= fanWidth;
        
        
//        NSLog(@"cl is %@", menuItem);
        
        [_menuItems addObject:menuItem];
        
    }
    
}


- (void)createOddItems {
    
    CGFloat fanWidth = M_PI*2/_count;
    CGFloat mid = 0;
    
    for (int i = 0; i < _count; i++) {
        
        RWWheelMenuItem *menuItem = [[RWWheelMenuItem alloc] init];
        menuItem.midValue = mid;
        menuItem.minValue = mid - (fanWidth/2);
        menuItem.maxValue = mid + (fanWidth/2);
        menuItem.value = i;
        
        mid -= fanWidth;
        
        if (menuItem.minValue < - M_PI) {
            
            mid = -mid;
            mid -= fanWidth;
            
        }
        
        
        [_menuItems addObject:menuItem];
        
//        NSLog(@"cl is %@", menuItem);
        
    }
    
}

- (float)calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist < self.frame.size.width / 4 || dist > self.frame.size.width / 2)
    {
        // forcing a tap to be on the ferrule
//        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
	float dx = touchPoint.x - _contentView.center.x;
	float dy = touchPoint.y - _contentView.center.y;
	deltaAngle = atan2(dy,dx);
    
    _transform = _contentView.transform;
    
    
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
	CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
    if (dist < self.frame.size.width / 4 || dist > self.frame.size.width / 2)
    {
        // a drag path too close to the center
//        NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
        
        // here you might want to implement your solution when the drag
        // is too close to the center
        // You might go back to the menuItem previously selected
        // or you might calculate the menuItem corresponding to
        // the "exit point" of the drag.
        
    }
	
	float dx = pt.x  - _contentView.center.x;
	float dy = pt.y  - _contentView.center.y;
	float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    
    _contentView.transform = CGAffineTransformRotate(_transform, -angleDifference);
    
    return YES;
	
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    CGFloat radians = atan2f(_contentView.transform.b, _contentView.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (RWWheelMenuItem *c in _menuItems) {
        
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) { // we are in the positive quadrant
                    
                    newVal = radians - M_PI;
                    
                } else { // we are in the negative one
                    
                    newVal = M_PI + radians;
                    
                }
                _currentIndex = c.value;
                
            }
            
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
            
            newVal = radians - c.midValue;
            _currentIndex = c.value;
            
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGAffineTransform t = CGAffineTransformRotate(_contentView.transform, -newVal);
    _contentView.transform = t;
    
    [UIView commitAnimations];
    
    [self menuItemDidChange:_currentIndex];
    
}

- (void)menuButtonClicked:(id)sender
{
    if (_menuItemClickBlock) {
        self.menuItemClickBlock(((UIButton *)sender).tag);
    }
}

- (void)menuItemDidChange:(int)position {
    
    int labelIndex = 0;
    for (UILabel *label in _menuTitleLabels) {
        if (labelIndex == position) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor whiteColor];
        }
        labelIndex ++;
    }
    if (_menuButtonImageNames.count > 0) {
        
        UIImage *buttonImage = [UIImage imageNamed:[_menuButtonImageNames objectAtIndex:position]];
        [_menuButton setBackgroundImage:buttonImage
                               forState:UIControlStateNormal];
        
        _menuButton.frame = CGRectMake((self.bounds.size.width - buttonImage.size.width) / 2, (self.bounds.size.height - buttonImage.size.height) / 2, buttonImage.size.width, buttonImage.size.height);
        _menuButton.tag = position;
        [_menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
