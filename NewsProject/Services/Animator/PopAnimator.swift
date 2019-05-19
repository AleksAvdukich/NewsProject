//
//  PopAnimator.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    // MARK: Public Properties
    
    var presenting = true
    var dismissCompletion: (() -> Void)?
    
    
    // MARK: Private Properties
    
    private let duration = 0.5
    
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
//        let settingsView = presenting ? toView : fromView
        
        containerView.addSubview(toView)
//        containerView.bringSubviewToFront(settingsView) // При скрытии settingsView, settingsView - это fromView. Поверх него располагается toView. Но поскольку анимация проводится только для одного view контроллера (settingView), поэтому он выдвигается на передний план, т.е. чтобы была видна анимация.
        
//        settingsView.alpha = presenting ? 0.0 : 1.0
//        UIView.animate(withDuration: duration,
//                       animations: {
//                        settingsView.alpha = self.presenting ? 1.0 : 0.0
//        },
//                       completion: { _ in
//                        if !self.presenting {
//                            self.dismissCompletion?()
//                        }
//                        transitionContext.completeTransition(true)
//        }
//        )
        
        toView.frame = self.presenting ? CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        UIView.animate(withDuration: duration,
                       delay: 0,
                       animations: {
                        if self.presenting {
                            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
                            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                        } else {
                            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
                        }
        }) { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
}
