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
    
    func presentImageViewController(imageData: NamedImage)
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
    
    func presentImageViewController(imageData: NamedImage) {
        guard let imageViewController = UIStoryboard(name: "ImageViewController", bundle: nil).instantiateInitialViewController() as? ImageViewController,
              let imageResource = imageData.resource
        else {
            return
        }
        imageViewController.imageViewHeroID = imageData.name
        imageViewController.imageResource = imageResource
        imageViewController.modalPresentationStyle = .fullScreen
        viewController?.present(imageViewController, animated: true)
    }
}

// MARK: private extension

private extension CollectionRouter {}
