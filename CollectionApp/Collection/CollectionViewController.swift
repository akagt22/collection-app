//
//  CollectionViewController.swift
//  CollectionApp
//
//  Created by Okamoto Akihiro on 2025/01/16.
//

import UIKit

// MARK: View (Presenter -> View)

protocol CollectionView: AnyObject {
    // MARK: VIPER Properties

    var presenter: CollectionPresentation! { get set }

    // MARK: func
    
    func reloadCollectionViewData()
}

final class CollectionViewController: UIViewController, UICollectionViewDelegate {

    // MARK: VIPER Properties

    var presenter: CollectionPresentation!

    // MARK: IBOutlet

    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: Public Properties

    // MARK: Private Properties
    
    private let layout = UICollectionViewFlowLayout()
    private let sectionInset: CGFloat = 8
    private let spacing: CGFloat = 16
    private let rowNumber: CGFloat = 3
    private var collectionCellHeight: CGFloat = 0
    private var collectionCellWidth: CGFloat = 0

    // MARK: init
    
    // MARK: deinit
    
    // MARK: Lifecycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = CollectionPresenter()
        let interactor = CollectionInteractor()
        let router = CollectionRouter()
        
        self.presenter = presenter
        presenter.view = self
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = self
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // セル同士の間隔
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        // セルの周りの余白(画面端)
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        
        // viewDidLoad~ViewWillAppearでは横幅の値が正しくない
        let totalInsetSize: CGFloat = sectionInset * 2 + spacing * (rowNumber - 1)
        collectionCellWidth = (collectionView.frame.width - totalInsetSize) / rowNumber
        collectionCellHeight = collectionCellWidth
        print("screenWidth：\(collectionView.frame.width)、totalInsetSize：\(totalInsetSize)、width：\(collectionCellWidth)、height：\(collectionCellHeight)")
    }
    
    // MARK: func
}

// MARK: View (Presenter -> View)

extension CollectionViewController: CollectionView {
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    
    // cellの数の指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(labelText: presenter.collectionContent(index: indexPath.row))
        return cell
    }
    
    // セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // プラスセルタップ
        if indexPath.row == presenter.indexOfPlusCell() {
            presenter.plusCellDidTap()
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // セルのサイズ指定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
}

extension CollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row >= presenter.indexOfPlusCell() { return [] }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        // アプリ内完結ならlocalObject。アプリ外にdrag&dropするならNSItemProvider(object:)に渡す値を入れる
        dragItem.localObject = presenter.collectionContent(index: indexPath.row)
        return [dragItem]
    }
}

extension CollectionViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
    }
}


// MARK: private extension

private extension CollectionViewController {}
