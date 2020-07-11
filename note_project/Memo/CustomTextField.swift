//
//  CustomTextField.swift
//  note_project
//
//  Created by rui on 2020/07/11.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class CustomTextField: UITextView{

    var lineHeight: CGFloat = 13.8

    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let numberOfLines = Int(rect.height/lineHeight)
        let topInset = textContainerInset.top
        
        
        
        UIColor(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setStroke() // 色をセット

        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight

            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            ctx?.addPath(line)
        }

        ctx?.strokePath()

        super.draw(rect)
    }
}
