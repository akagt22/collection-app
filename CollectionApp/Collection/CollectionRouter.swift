//
//  CollectionRouter.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/16.
//

import UIKit

// MARK: Wireframe (Presenter -> Router)

protocol CollectionWireframe: AnyObject {
    // MARK: func
    
    func presentImageViewController(image: ImageResource)
}

// MARK: Wireframe (Presenter -> Router)

class CollectionRouter: CollectionWireframe {
    // MARK: VIPER Properties

    weak var viewController: CollectionViewController?

    // MARK: Public Properties

    // MARK: Private Properties

    // MARK: init

    // MARK: deinit

    // MARK: func
    
    func presentImageViewController(image: ImageResource) {
        guard let imageViewController = UIStoryboard(name: "ImageViewController", bundle: nil).instantiateInitialViewController() as? ImageViewController
        else {
            return
        }
        imageViewController.imageResource = image
        imageViewController.modalPresentationStyle = .fullScreen
        viewController?.present(imageViewController, animated: false)
    }
}

// MARK: private extension

private extension CollectionRouter {}
