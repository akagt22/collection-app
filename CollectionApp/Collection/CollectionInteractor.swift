//
//  CollectionInteractor.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/16.
//

// MARK: UseCase (Presenter -> Interactor)

protocol CollectionUseCase: AnyObject {
    // MARK: VIPER Properties

    var output: CollectionInteractorOutput? { get set }

    // MARK: func
    
    func addCollectionContent()
    func collectionArrayCount() -> Int
    func collectionContent(index: Int) -> String
    func indexOfPlusCell() -> Int
    func insertCollectionContent(data: String, at row: Int)
    func removeCollectionContent(at row: Int)
}

// MARK: UseCase (Presenter -> Interactor)

class CollectionInteractor: CollectionUseCase {
    // MARK: VIPER Properties

    weak var output: CollectionInteractorOutput?

    // MARK: Public Properties

    // MARK: Private Properties
    
    private var collectionArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "+"]

    // MARK: init

    // MARK: deinit

    // MARK: func
    func addCollectionContent() {
        collectionArray.insert(String(collectionArray.count), at: collectionArrayCount() - 1)
    }
    
    func collectionArrayCount() -> Int {
        return collectionArray.count
    }
    
    func collectionContent(index: Int) -> String {
        return collectionArray[index]
    }
    
    func indexOfPlusCell() -> Int {
        return collectionArray.count - 1
    }
    
    func insertCollectionContent(data: String, at row: Int) {
        collectionArray.insert(data, at: row)
    }
    
    func removeCollectionContent(at row: Int) {
        collectionArray.remove(at: row)
    }
}

// MARK: private extension

private extension CollectionInteractor {}
