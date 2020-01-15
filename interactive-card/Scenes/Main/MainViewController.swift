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
    var cardAnimators: [UIViewPropertyAnimator] = []
    var fractionOfAnimationComplete: CGFloat = 0
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
            print("Next state: \(state)")
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                print("Creating cardView animator")
                switch state {
                case .expanded:
                    print("Adding cardView y = \(self.view.frame.height - self.cardView.frame.height)")
                    self.cardView.frame.origin.y = self.view.frame.height - self.cardView.frame.height
                case .collapsed:
                    print("Adding cardView y = \(self.view.frame.maxY)")
                    self.cardView.frame.origin.y = self.view.frame.maxY
                }
            }
            frameAnimator.addCompletion { _ in
                print("Card visible goes from \(self.cardVisible) to \(!self.cardVisible)")
                print("Removing all animators from array")
                self.cardAnimators.removeAll()
            }
            print("Starting animation")
            frameAnimator.startAnimation()
            print("Adding animator in array")
            cardAnimators.append(frameAnimator)
        }
    }
    
    @objc func openCardButtonTapped(_ sender: UIButton) {
        animateTransitionIfNeeded(state: nextState, duration: 0.7)
    }
    
    @objc func cardViewPanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            print("Panning began")
            if cardAnimators.isEmpty {
                cardVisible = true
                animateTransitionIfNeeded(state: nextState, duration: 0.7)
            }
            for animator in cardAnimators {
                animator.pauseAnimation()
                animationProgressWhenInterrupted = animator.fractionComplete
                fractionOfAnimationComplete = animator.fractionComplete
            }
        case .changed:
            let translation = recognizer.translation(in: self.cardView)
            fractionOfAnimationComplete = translation.y / self.cardView.frame.height
            fractionOfAnimationComplete = fractionOfAnimationComplete + animationProgressWhenInterrupted
            for animator in cardAnimators {
                animator.fractionComplete = fractionOfAnimationComplete
            }
        case .ended:
            print(fractionOfAnimationComplete)
            if fractionOfAnimationComplete > 0.3 {
                cardVisible = !cardVisible
                for animator in cardAnimators {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
            } else {
                cardVisible = false
                cardAnimators.removeAll()
                animateTransitionIfNeeded(state: nextState, duration: 0.4)
            }
        default:
            break
        }
    }
}

