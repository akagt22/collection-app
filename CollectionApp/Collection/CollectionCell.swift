//
//  CollectionCell.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/28.
//

import Hero
import UIKit

class CollectionCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    // 意味なし
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension CollectionCell {    
    func deleteImage() {
        imageView.image = nil
    }
    
    func setupCell(imageResource: ImageResource) {
        imageView.image = UIImage(resource: imageResource)
    }
    
    func setImageViewHeroID(id: String) {
        imageView.heroID =  id
    }
}
