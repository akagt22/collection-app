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
    func collectionContent(index: Int) -> ImageResource
    func indexOfPlusCell() -> Int
    func insertCollectionContent(data: ImageResource, at row: Int)
    func removeCollectionContent(at row: Int)
    func replaceCollectionContent(from x: Int, to y: Int)
}

// MARK: UseCase (Presenter -> Interactor)

class CollectionInteractor: CollectionUseCase {
    // MARK: VIPER Properties

    weak var output: CollectionInteractorOutput?

    // MARK: Public Properties

    // MARK: Private Properties
    
    private var collectionArray: [ImageResource] = [.image0,.image1,.image2,.image3,.image4,.image5,.image6,.image7,.image8,.image9,.image10,.image11]

    // MARK: init

    // MARK: deinit

    // MARK: func
    func addCollectionContent() {
        //collectionArray.insert(String(collectionArray.count), at: collectionArrayCount() - 1)
    }
    
    func collectionArrayCount() -> Int {
        return collectionArray.count
    }
    
    func collectionContent(index: Int) -> ImageResource {
        return collectionArray[index]
    }
    
    func indexOfPlusCell() -> Int {
        return collectionArray.count - 1
    }
    
    func insertCollectionContent(data: ImageResource, at row: Int) {
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
