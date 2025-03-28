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
    
    func deleteCollectionItems(at indexPathArray:[IndexPath])
    func insertCollectionItems(at indexPathArray:[IndexPath])
    func reloadCollectionViewData()
}

final class CollectionViewController: UIViewController {

    // MARK: VIPER Properties

    var presenter: CollectionPresentation!

    // MARK: IBOutlet

    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
            layout.minimumLineSpacing = spacing // 縦
            layout.minimumInteritemSpacing = spacing // 横

            // セルの周りの余白(画面端)
            layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
            
            // viewDidLoad~ViewWillAppearでは横幅の値が正しくない
            let totalInsetSize: CGFloat = sectionInset * 2 + spacing * (rowNumber - 1)

            
            let cellWidth = (collectionView.frame.width - totalInsetSize) / rowNumber
            let cellHeight = cellWidth
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            collectionView.collectionViewLayout = layout
            
            print("screenWidth：\(collectionView.frame.width)、totalInsetSize：\(totalInsetSize)、width：\(cellWidth)、height：\(cellHeight)")

        }
    }
    
    // MARK: Public Properties

    // MARK: Private Properties
    
    private let sectionInset: CGFloat = 8
    private let spacing: CGFloat = 16
    private let rowNumber: CGFloat = 4

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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
    
    // MARK: func
}

// MARK: View (Presenter -> View)

extension CollectionViewController: CollectionView {
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
    
    func insertCollectionItems(at indexPathArray: [IndexPath]) {
        collectionView.insertItems(at: indexPathArray)
    }
    
    func deleteCollectionItems(at indexPathArray: [IndexPath]) {
        collectionView.deleteItems(at: indexPathArray)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    // cellの数の指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return presenter.numberOfCells(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(namedImage: presenter.collectionContent(index: indexPath))
        return cell
    }
    
    // セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeader", for: indexPath) as? CollectionHeader else {
            return UICollectionReusableView()
        }
        
        header.setupHeader(title: presenter.sectionName(section: indexPath.section))
        return header
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    // セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= presenter.numberOfCells(section: indexPath.section) { return }
            
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell
        let imageData = presenter.collectionContent(index: indexPath)
        cell?.setImageViewHeroID(id: imageData.name ?? "")
        presenter.cellDidTap(imageData: imageData)
    }
}

// ドラッグ可能対象の決定
extension CollectionViewController: UICollectionViewDragDelegate {
    // ドラッグしようとした時
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // スケルトンセルはドラッグ不可
        if indexPath.row >= presenter.skeletonCellRow(section: indexPath.section)  { return [] }
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = "abc"
        
        // ドラッグ可
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

// ドロップ
extension CollectionViewController: UICollectionViewDropDelegate {
    // cellを放した時
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard var destinationIndexPath = coordinator.destinationIndexPath,
              let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath else { return }
        
        
        let skeletonRow = presenter.skeletonCellRow(section: destinationIndexPath.section)
        
        if skeletonRow > 0 && destinationIndexPath.row >= skeletonRow {
            if destinationIndexPath.section == sourceIndexPath.section {
                destinationIndexPath.row = skeletonRow - 1
            } else {
                destinationIndexPath.row = skeletonRow
            }
        }
        
        // 配列とセルの更新処理を呼び出し
        if coordinator.proposal.operation == .move {
            self.updateItem(coordinator: coordinator, destinationIndex: destinationIndexPath, collectionView: collectionView)
        } else if coordinator.proposal.operation == .forbidden {
            print("forbidden")
        }
    }
    
    // cellをドロップ先の上に移動した時
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // .move：移動、.insertAtDestinationIndexPath：ドラッグ＆ドロップで移動先に「挿入する」動作を明示的に指定
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

}


// MARK: private extension

private extension CollectionViewController {
    func updateItem(coordinator: any UICollectionViewDropCoordinator, destinationIndex: IndexPath, collectionView: UICollectionView){
        guard let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath else { return }
        
        // ドラッグ時に与えた情報取得
        let movedData = item.dragItem.localObject as? String
        
        // チラつき防止
        let cell = collectionView.cellForItem(at: sourceIndexPath) as? CollectionCell
        cell?.deleteImage()
        
        // performBatchUpdates：複数のセルの挿入・削除を行う際に使用する
        collectionView.performBatchUpdates({
            presenter.dragAndDrop(dragPosition: sourceIndexPath, dropPosition: destinationIndex)
        })
        
        // ドロップ実行(ドロップアニメーション)
        coordinator.drop(item.dragItem, toItemAt: destinationIndex)
    }
}
