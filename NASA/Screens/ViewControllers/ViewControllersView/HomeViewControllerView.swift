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
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 400)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    let settingBarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: ImageName.slider), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let progressView: UIActivityIndicatorView = {
        let progress =  UIActivityIndicatorView(style: .large)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.hidesWhenStopped = true
        return progress
    }()

    let searchHistoryBarButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: ImageName.searchHistory), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

// MARK: - NSLayoutConstraints
    private lazy var collectionConstraintsWithProgressView = [
        marsPhotosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
        marsPhotosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        marsPhotosCollectionView.topAnchor.constraint(equalTo: topAnchor),
        marsPhotosCollectionView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -40)
    ]

    private lazy var collectionConstraintsWithoutProgressView = [
        marsPhotosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
        marsPhotosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        marsPhotosCollectionView.topAnchor.constraint(equalTo: topAnchor),
        marsPhotosCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]

    private lazy var progressViewConstraints = [
        progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
    ]
    
// MARK: - Handle animation
    func startAnimating() {
        // Settign intsets back to zero so scrolling work properly
        marsPhotosCollectionView.contentInset = UIEdgeInsets.zero
        NSLayoutConstraint.deactivate(collectionConstraintsWithoutProgressView)
        addSubview(progressView)
        NSLayoutConstraint.activate(progressViewConstraints)
        NSLayoutConstraint.activate(collectionConstraintsWithProgressView)
        progressView.startAnimating()
    }

    func stopAnimating() {
        NSLayoutConstraint.deactivate(collectionConstraintsWithProgressView)
        NSLayoutConstraint.deactivate(progressViewConstraints)
        NSLayoutConstraint.activate(collectionConstraintsWithoutProgressView)
        progressView.stopAnimating()
        progressView.removeFromSuperview()
        // This inset is needed when loading a new batch of photos so collectionView will not scroll down
        marsPhotosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 125, right: 0)
    }

// MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        NSLayoutConstraint.activate(collectionConstraintsWithoutProgressView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

// MARK: - Initial setup
    private func buildHierarchy() {
        addSubview(marsPhotosCollectionView)
    }
}

