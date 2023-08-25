//
//  HomeScreenView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import UIKit

final class HomeViewControllerView: UIView {
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let applicationName: UILabel = {
        let label = UILabel()
        label.text = "NASA"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var marsPhotosCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.register(MarsPhotosCollectionViewCell.self, forCellWithReuseIdentifier: MarsPhotosCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    private func addDelegates() {
        marsPhotosCollectionView.dataSource = self
        marsPhotosCollectionView.delegate = self
    }

    private func buildHierarchy() {
        addSubview(settingsButton)
        addSubview(marsPhotosCollectionView)
        addSubview(applicationName)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: 44).isActive = true
        settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: 44).isActive = true

        applicationName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        applicationName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        applicationName.bottomAnchor.constraint(equalTo: applicationName.topAnchor, constant: 44).isActive = true

        marsPhotosCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        marsPhotosCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        marsPhotosCollectionView.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 20).isActive = true
        marsPhotosCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        addDelegates()
//        setBackgroundImage()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

//    private func setBackgroundImage() {
////        let background = UIImageView(frame: UIScreen.main.bounds)
////        background.image = UIImage(named: "space")
////        background.contentMode = .scaleAspectFill
////        insertSubview(background, at: 0)
//    }
    
}

extension HomeViewControllerView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarsPhotosCollectionViewCell.identifier, for: indexPath) as! MarsPhotosCollectionViewCell
        return cell
    }
}


