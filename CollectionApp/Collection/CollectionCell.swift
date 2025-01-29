//
//  CollectionCell.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/28.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet private var label: UILabel!
    
    func setupCell(labelText: String) {
        label.text = labelText
    }
}
