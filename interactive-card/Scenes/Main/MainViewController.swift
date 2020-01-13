//
//  MainViewController.swift
//  interactive-card
//
//  Created by Erik Andresen on 13/01/2020.
//  Copyright © 2020 Shabibi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var cardView: UIView!
    var cardHeight: CGFloat = 500
    var cardAnimators: [UIViewPropertyAnimator] = []
    var animationProgressWhenInterrupted: CGFloat = 0
    enum CardState {
        case expanded
        case collapsed
    }
    var cardVisible = false
    var nextState: CardState {
        return cardVisible ? CardState.collapsed : CardState.expanded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    override func viewDidLayoutSubviews() {
        cardView.frame.origin.y = view.frame.maxY
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if cardAnimators.isEmpty {
            //This is what is animated
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardView.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardView.frame.origin.y = self.view.frame.maxY
                }
            }
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.cardAnimators.removeAll()
            }
            
            frameAnimator.startAnimation()
            cardAnimators.append(frameAnimator)
        }
    }
    
    @objc func openCardButtonTapped(_ sender: UIButton) {
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
        //cardView.frame.origin.y = view.frame.maxY - 500
    }
    
    @objc func cardViewPanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if cardAnimators.isEmpty {
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
            }
            for animator in cardAnimators {
                animator.pauseAnimation()
                animationProgressWhenInterrupted = animator.fractionComplete
            }
        case .changed:
            let translation = recognizer.translation(in: self.cardView)
            var fractionCompleted = translation.y / cardHeight
            fractionCompleted = cardVisible ? fractionCompleted : -fractionCompleted
            for animator in cardAnimators {
                animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
            }
        case .ended:
            for animator in cardAnimators {
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            break
        }
    }
}

