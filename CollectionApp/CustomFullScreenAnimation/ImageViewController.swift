//
//  ImageViewController.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/03/21.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    var imageResource: ImageResource = .image0

    override func viewDidLoad() {
        imageView.image = UIImage(resource: imageResource)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func popView() {
        self.dismiss(animated: true)
    }
}
