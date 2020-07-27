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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let newText: String = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= 3
    }

    private func numberOfLines(orgTextView: UITextView, newText: String) -> Int {

        // UITextViewを複製します。iOS12では古いAPIを使っているというような警告がでます。
        let cloneTextView = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: orgTextView)) as! UITextView

        cloneTextView.text = newText + " "

        let layoutManager = cloneTextView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }

        return numberOfLines
    }
}
