//
//  CustomLabel.swift
//  note_project
//
//  Created by rui on 2020/07/11.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

class CustomLabel: UITextField {
    // 下線用のUIViewを作っておく
    let underline: UIView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        composeUnderline() // 下線のスタイルセットおよび追加処理

        self.borderStyle = .none
        self.placeholder = "教科名を入力してください"  // 何を入力すべきか
    }

    private func composeUnderline() {
        self.underline.frame = CGRect(
            x: 0,                    // x, yの位置指定は親要素,
            y: self.frame.height,    // この場合はCustomTextFieldを基準にする
            width: self.frame.width,
            height: 2.5)

        self.underline.backgroundColor = UIColor(red:0.36, green:0.61, blue:0.93, alpha:1.0)

        self.addSubview(self.underline)
        self.bringSubviewToFront(self.underline)
    }
}
