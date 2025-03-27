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
    
    func collectionArrayCount(type: SectionType) -> Int
    func collectionContent(index: Int, type: SectionType) -> NamedImage
    func insertCollectionContent(data: NamedImage, at row: Int, type: SectionType)
    func removeCollectionContent(at row: Int, type: SectionType)
    func replaceCollectionContent(from x: Int, to y: Int, type: SectionType)
}

struct NamedImage {
    var resource: ImageResource? = nil
    var name: String? = nil
}

enum SectionType: Int {
    case favorite = 0
    case normal = 1
}

extension SectionType {
    var name: String {
        switch self {
        case .favorite:
            return "お気に入り"
        case .normal:
            return "コレクション"
        }
    }
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
    
    private var favoriteCollectionArray: [NamedImage] = [NamedImage()]
    
    // MARK: init
    init() {
        collectionArray.append(NamedImage())
    }

    // MARK: deinit

    // MARK: func
    
    func collectionArrayCount(type: SectionType) -> Int {
        switch type {
        case .favorite:
            return favoriteCollectionArray.count
        case .normal:
            return collectionArray.count
        }
    }
    
    func collectionContent(index: Int, type: SectionType) -> NamedImage {
        switch type {
        case .favorite:
            return favoriteCollectionArray[index]
        case .normal:
            return collectionArray[index]
        }
    }
    
    func insertCollectionContent(data: NamedImage, at row: Int, type: SectionType) {
        switch type {
        case .favorite:
            favoriteCollectionArray.insert(data, at: row)
        case .normal:
            collectionArray.insert(data, at: row)
        }
    }
    
    func removeCollectionContent(at row: Int, type: SectionType) {
        switch type {
        case .favorite:
            favoriteCollectionArray.remove(at: row)
        case .normal:
            collectionArray.remove(at: row)
        }
    }
    
    func replaceCollectionContent(from x: Int, to y: Int, type: SectionType) {
        switch type {
        case .favorite:
            let tmp = favoriteCollectionArray[x]
            favoriteCollectionArray.remove(at: x)
            favoriteCollectionArray.insert(tmp, at: y)
        case .normal:
            let tmp = collectionArray[x]
            collectionArray.remove(at: x)
            collectionArray.insert(tmp, at: y)
        }
    }
}

// MARK: private extension

private extension CollectionInteractor {}
