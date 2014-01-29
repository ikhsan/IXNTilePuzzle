//
//  IXNViewController.m
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "IXNViewController.h"
#import "IXNTilePuzzle.h"

static const NSTimeInterval AnimationSpeed = 0.2;

@interface IXNViewController () <IXNTileBoardViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, assign, readonly) UIImage *boardImage;
@property (nonatomic, readonly) NSInteger boardSize;
@property (nonatomic) NSInteger steps;

@end

@implementation IXNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self restart:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)boardImage
{
    return [UIImage imageNamed:@"pug.jpg"];
}

- (NSInteger)boardSize
{
    return self.sizeSegmentedControl.selectedSegmentIndex + 3;
}

- (void)setSteps:(NSInteger)steps
{
    _steps = steps;
    
    self.stepsLabel.text = [NSString stringWithFormat:@"%d", self.steps];
}

#pragma mark - Actions

- (IBAction)restart:(UIButton *)sender
{
    [self.board playWithImage:self.boardImage size:self.boardSize];
    [self.board shuffleTimes:100];
    self.steps = 0;
    
    [self hideImage];
}

- (void)showImage
{
    UIImageView *originalImage = [[UIImageView alloc] initWithImage:self.boardImage];
    originalImage.frame = self.board.frame;
    originalImage.alpha = 0.0;
    
    [originalImage.layer setShadowColor:[UIColor blackColor].CGColor];
    [originalImage.layer setShadowOpacity:0.65];
    [originalImage.layer setShadowRadius:1.5];
    [originalImage.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    [originalImage.layer setShadowPath:[[UIBezierPath bezierPathWithRect:originalImage.layer.bounds] CGPath]];
    
    [self.view addSubview:originalImage];
    
    [UIView animateWithDuration:AnimationSpeed animations:^{
        originalImage.alpha = 1.0;
        self.board.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.imageView = originalImage;
    }];
}

- (void)hideImage
{
    if (!self.imageView) return;
    
    [UIView animateWithDuration:AnimationSpeed animations:^{
        self.imageView.alpha = 0.0;
        self.board.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }];
}

- (IBAction)buttonTouchDown:(id)sender
{
    [self showImage];
}

- (IBAction)buttonTouchUpInside:(id)sender
{
    [self hideImage];
}

- (IBAction)sizeChanged:(UISegmentedControl *)sender
{
    [self restart:nil];
}

#pragma mark - Tile Board Delegate Method

- (void)tileBoardView:(IXNTileBoardView *)tileBoardView tileDidMove:(CGPoint)position
{
    NSLog(@"tile move : %@", [NSValue valueWithCGPoint:position]);
    self.steps++;
}

- (void)tileBoardViewDidFinished:(IXNTileBoardView *)tileBoardView
{
    NSLog(@"tile is completed");
    [self showImage];
    
    NSString *message = [NSString stringWithFormat:@"You've completed a %d x %d puzzle with %d steps. Press restart button to play again.", self.boardSize, self.boardSize, self.steps];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:message delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
}

@end
