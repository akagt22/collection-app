//
//  ImageViewController.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/03/21.
//

import Hero
import UIKit

class ImageViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageViewHeight: NSLayoutConstraint!
    
    var imageResource: ImageResource = .image0
    var imageViewHeroID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.heroID = imageViewHeroID
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popView))
        self.view.addGestureRecognizer(tapGesture)
        
        let image = UIImage(resource: imageResource)
        let aspectRatio = image.size.height / image.size.width
        imageViewHeight.constant = imageView.frame.width * aspectRatio
        imageView.image = UIImage(resource: imageResource)
    }
    
    @objc func popView() {
        self.dismiss(animated: true)
    }
}
