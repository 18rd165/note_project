//
//  Cell.swift
//  note_project
//
//  Created by rui on 2020/07/11.
//  Copyright © 2020 18rd165. All rights reserved.
//

import UIKit

final class Cell: UICollectionViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var noteText: UITextView!
    static let aspectRatio: CGFloat = sqrt(2.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
}

