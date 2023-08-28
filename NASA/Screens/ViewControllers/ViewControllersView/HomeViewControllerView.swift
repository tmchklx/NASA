//
//  HomeScreenView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import UIKit

final class HomeViewControllerView: UIView {
// MARK: - Views initialization
     lazy var marsPhotosCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.register(MarsPhotosCollectionViewCell.self, forCellWithReuseIdentifier: MarsPhotosCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 400)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    let navigationBarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: ImageName.slider), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

// MARK: - Views layout
    override func layoutSubviews() {
        super.layoutSubviews()
        marsPhotosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        marsPhotosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        marsPhotosCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        marsPhotosCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

// MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

// MARK: - Initial setup
    private func buildHierarchy() {
        addSubview(marsPhotosCollectionView)
    }
}

