//
//  MainViewController+UI.swift
//  interactive-card
//
//  Created by Erik Andresen on 13/01/2020.
//  Copyright © 2020 Shabibi. All rights reserved.
//

import UIKit
import SnapKit

extension MainViewController {
    func createUI() {
        //Background
        view.backgroundColor = .white
        
        //Button for opening card
        let openCardButton = UIButton()
        openCardButton.setTitle("Open card", for: .normal)
        openCardButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        openCardButton.addTarget(self, action: #selector(openCardButtonTapped(_:)), for: .touchUpInside)
        openCardButton.setTitleColor(.black, for: .normal)
        openCardButton.setTitleColor(.lightGray, for: .highlighted)
        view.addSubview(openCardButton)
        openCardButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        //CardView
        cardView = UIView()
        cardView.backgroundColor = .yellow
        view.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.height.equalTo(500)
            $0.left.right.equalToSuperview()
        }
        
        //Area where you can drag the card
        let gestureArea = UIView()
        gestureArea.backgroundColor = .gray
        cardView.addSubview(gestureArea)
        gestureArea.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardViewPanned(_:)))
        gestureArea.addGestureRecognizer(panGesture)
    }
}
