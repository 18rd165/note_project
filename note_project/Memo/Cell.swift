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
    @IBOutlet weak var pages: UILabel!
    
    static let aspectRatio: CGFloat = 16.3/9

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
}

