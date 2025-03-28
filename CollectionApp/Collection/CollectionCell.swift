//
//  CollectionCell.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/28.
//

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
    
    func setImageViewHeroID(id: String) {
        imageView.heroID =  id
    }
    
    func setupCell(namedImage: NamedImage) {
        guard let imageResource = namedImage.resource else { return }
        imageView.image = UIImage(resource: imageResource)
    }
}
