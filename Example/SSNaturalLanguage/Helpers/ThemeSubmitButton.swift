//
//  ThemeButton.swift
//  NestlingsFeasibility
//
//  Created by Abhi Makadiya on 05/02/21.
//
import UIKit

class ThemeSubmitButton: UIButton {

    var originalButtonText: String?
    
    override func draw(_ rect: CGRect) {
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 74/225, green: 238/255, blue: 222/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 83/225, green: 105/255, blue: 235/255, alpha: 1.0).cgColor
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 10

        gradientLayer.shadowColor = UIColor.darkGray.withAlphaComponent(0.6).cgColor
        gradientLayer.shadowOffset = CGSize(width: 3.5, height: 3.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
}
