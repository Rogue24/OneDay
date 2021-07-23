//
//  JPImageresizer+Extension.h
//  JPImageresizerView
//
//  Created by 周健平 on 2019/8/2.
//

#import <QuartzCore/QuartzCore.h>

@interface CABasicAnimation (JPImageresizer)

+ (CABasicAnimation *)jpir_backwardsAnimationWithKeyPath:(NSString *)keyPath
                                               fromValue:(id)fromValue
                                                 toValue:(id)toValue
                                      timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                                duration:(NSTimeInterval)duration;

@end

@interface CALayer (JPImageresizer)

- (void)jpir_addBackwardsAnimationWithKeyPath:(NSString *)keyPath
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                           timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                     duration:(NSTimeInterval)duration;

@end

@interface NSURL (JPImageresizer)

- (NSString *)jpir_filePathWithoutExtension;

@end
