//
//  CollectionHeader.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/03/27.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    func setupHeader(title: String) {
        titleLabel.text = title
    }
}
