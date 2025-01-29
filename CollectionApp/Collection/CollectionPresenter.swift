//
//  CollectionPresenter.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/16.
//

// MARK: Presentation (View -> Presenter)

protocol CollectionPresentation: AnyObject {
    // MARK: VIPER Properties

    var view: CollectionView? { get set }
    var interactor: CollectionUseCase! { get set }
    var router: CollectionWireframe! { get set }

    // MARK: Lifecycle func

    // MARK: func
    
    func collectionContent(index: Int) -> String
    func plusCellDidTap()
    func indexOfPlusCell() -> Int
    func numberOfCells() -> Int
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
    
    func collectionContent(index: Int) -> String {
        interactor.collectionContent(index: index)
    }
    
    func plusCellDidTap() {
        interactor.addCollectionContent()
        view?.reloadCollectionViewData()
    }
    
    func indexOfPlusCell() -> Int {
        interactor.indexOfPlusCell()
    }
    
    func numberOfCells() -> Int {
        return interactor.collectionArrayCount()
    }
}

// MARK: InteractorOutput (Interactor -> Presenter)

extension CollectionPresenter: CollectionInteractorOutput {}

// MARK: private extension

private extension CollectionPresenter {}
