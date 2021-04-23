//
//  TextViewWithPlaceholder.swift
//  Nestlings
//
//  Created by Abhi Makadiya on 01/03/21.
//  Copyright © 2021 Simform Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

@IBDesignable class TextViewWithPlaceholder: UITextView {
    
    override var text: String! {
        get {
            if showingPlaceholder {
                return ""
            } else { return super.text }
        }
        set { super.text = newValue }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = UIColor.gray
    private var showingPlaceholder: Bool = true
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        if showingPlaceholder {
            text = nil
            textColor = nil
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        text = placeholderText
    }
    
}
