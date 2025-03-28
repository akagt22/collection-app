//
//  CollectionPresenter.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/16.
//

import Foundation

// MARK: Presentation (View -> Presenter)

protocol CollectionPresentation: AnyObject {
    // MARK: VIPER Properties

    var view: CollectionView? { get set }
    var interactor: CollectionUseCase! { get set }
    var router: CollectionWireframe! { get set }

    // MARK: Lifecycle func

    // MARK: func

    func cellDidTap(imageData: NamedImage)
    func collectionContent(index: IndexPath) -> NamedImage
    func dragAndDrop(dragPosition: IndexPath, dropPosition: IndexPath)
    func numberOfCells(section: Int) -> Int
    func numberOfSection() -> Int
    func sectionName(section: Int) -> String
    func skeletonCellRow(section: Int) -> Int
}

// MARK: InteractorOutput (Interactor -> Presenter)

protocol CollectionInteractorOutput: AnyObject {}

// MARK: Presentation (View -> Presenter)

class CollectionPresenter: CollectionPresentation {

    // MARK: VIPER Properties

    weak var view: CollectionView?
    var interactor: CollectionUseCase!
    var router: CollectionWireframe!

    // MARK: Public Properties

    // MARK: Private Properties

    // MARK: init

    // MARK: deinit

    // MARK: Lifecycle func

    // MARK: func
    
    func cellDidTap(imageData: NamedImage) {
        router.presentImageViewController(imageData: imageData)
    }
    
    func collectionContent(index: IndexPath) -> NamedImage {
        guard let sectionType = SectionType(rawValue: index.section) else {
            return NamedImage(resource: .image0, name: "")
        }
        return interactor.collectionContent(index: index.row, type: sectionType)
    }
    
    func dragAndDrop(dragPosition: IndexPath, dropPosition: IndexPath) {
        let isSameSection = dragPosition.section == dropPosition.section
        
        // セクションが同じ場合
        if isSameSection {
            let sectionType = SectionType(rawValue: dragPosition.section)!
            interactor.replaceCollectionContent(from: dragPosition.row, to: dropPosition.row, type: sectionType)
        } else {
            let data = collectionContent(index: dragPosition)
            let fromSection = SectionType(rawValue: dragPosition.section)!
            let toSection = SectionType(rawValue: dropPosition.section)!
            
            interactor.insertCollectionContent(data: data, at: dropPosition.row, type: toSection)
            interactor.removeCollectionContent(at: dragPosition.row, type: fromSection)
        }

        // アイテムの削除と挿入
        view?.deleteCollectionItems(at: [dragPosition])
        view?.insertCollectionItems(at: [dropPosition])
    }
    
    func numberOfCells(section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
         return interactor.collectionArrayCount(type: sectionType)
    }
    
    func numberOfSection() -> Int {
        return 2
    }
    
    func sectionName(section: Int) -> String {
        return SectionType(rawValue: section)?.name ?? ""
    }
    
    func skeletonCellRow(section: Int) -> Int {
        return interactor.collectionArrayCount(type: SectionType(rawValue: section)!) - 1
    }
}

// MARK: InteractorOutput (Interactor -> Presenter)

extension CollectionPresenter: CollectionInteractorOutput {}

// MARK: private extension

private extension CollectionPresenter {}
