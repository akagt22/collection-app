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
    
    func collectionArrayCount() -> Int
    func collectionContent(index: Int) -> NamedImage
    func indexOfCrossCell() -> Int
    func insertCollectionContent(data: NamedImage, at row: Int)
    func removeCollectionContent(at row: Int)
    func replaceCollectionContent(from x: Int, to y: Int)
}

struct NamedImage {
    let resource: ImageResource
    let name: String
}

// MARK: UseCase (Presenter -> Interactor)

class CollectionInteractor: CollectionUseCase {
    // MARK: VIPER Properties

    weak var output: CollectionInteractorOutput?

    // MARK: Public Properties

    // MARK: Private Properties
    
    private var collectionArray: [NamedImage] = (0...10).map {
        NamedImage(resource: ImageResource(name: "image\($0)", bundle: .main), name: "Image\($0)")
    }

    // MARK: init

    // MARK: deinit

    // MARK: func
    
    func collectionArrayCount() -> Int {
        return collectionArray.count
    }
    
    func collectionContent(index: Int) -> NamedImage {
        return collectionArray[index]
    }
    
    func indexOfCrossCell() -> Int {
        return collectionArray.count - 1
    }
    
    func insertCollectionContent(data: NamedImage, at row: Int) {
        collectionArray.insert(data, at: row)
    }
    
    func removeCollectionContent(at row: Int) {
        collectionArray.remove(at: row)
    }
    
    func replaceCollectionContent(from x: Int, to y: Int) {
        let tmp = collectionArray[x]
        collectionArray.remove(at: x)
        collectionArray.insert(tmp, at: y)
    }
}

// MARK: private extension

private extension CollectionInteractor {}
