//
//  HomeViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/24/23.
//

import UIKit

fileprivate struct HomeViewControllerConstants {
    let barButtonSize: CGSize = CGSize(width: 30, height: 30)
}

final class HomeViewController: UIViewController {
    private let homeScreenView = HomeViewControllerView()
    private let homeViewModel = HomeViewModel()
    private let constants = HomeViewControllerConstants()

    override func loadView() {
        view = homeScreenView
    }

    override func viewDidLoad()  {
        super.viewDidLoad()
        addDelegatesAndTargets()
        loadDataAtAppLaunch()
        setupNavigationBar()
        handleReceivedData()
    }

    private func setupNavigationBar() {
        navigationItem.title = "NASA"

        let settingsBarButton = UIBarButtonItem(customView: homeScreenView.settingBarButton)
        let settingsButtonCurrentWidth = settingsBarButton.customView?.widthAnchor.constraint(
            equalToConstant: constants.barButtonSize.width)
        let settingsButtonCurrentHeight = settingsBarButton.customView?.heightAnchor.constraint(
            equalToConstant: constants.barButtonSize.height)
        settingsButtonCurrentWidth?.isActive = true
        settingsButtonCurrentHeight?.isActive = true

        let historyBarButton = UIBarButtonItem(customView: homeScreenView.searchHistoryBarButton)
        let historyButtonCurrentWidth = historyBarButton.customView?.widthAnchor.constraint(
            equalToConstant: constants.barButtonSize.width)
        let historyButtonCurrentHeight = historyBarButton.customView?.heightAnchor.constraint(
            equalToConstant: constants.barButtonSize.height)
        historyButtonCurrentWidth?.isActive = true
        historyButtonCurrentHeight?.isActive = true

        navigationItem.leftBarButtonItem = historyBarButton
        navigationItem.rightBarButtonItem = settingsBarButton
    }

    private func addDelegatesAndTargets() {
        homeScreenView.marsPhotosCollectionView.delegate = self
        homeScreenView.marsPhotosCollectionView.dataSource = self
        homeScreenView.settingBarButton.addTarget(
            self,
            action: #selector(settingsButtonTapped),
            for: .touchUpInside
        )

        homeScreenView.searchHistoryBarButton.addTarget(
            self,
            action: #selector(searchHistoryButtonTapped),
            for: .touchUpInside
        )
    }

    private func loadDataAtAppLaunch() {
        homeViewModel.fetchData(for: .latestPhotos(rover: .curiosity)) {
            self.homeViewModel.loadBatch {
                DispatchQueue.main.async {
                    self.homeScreenView.marsPhotosCollectionView.reloadData()
                }
            }
        }
    }

    private func handleReceivedData() {
        homeViewModel.onDataReceived = { [ weak self ] didFetchNasaData in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }

            DispatchQueue.main.async {
                if didFetchNasaData {
                    self.homeScreenView.marsPhotosCollectionView.reloadData()
                } else {
                    Alerts.showNoPhotosFetchedAlert(on: self)
                }
            }
        }
    }

    // MARK: - Selectors
    @objc private func settingsButtonTapped() {
        let destinationViewController = SettingsViewController()
        destinationViewController.modalPresentationStyle = .popover
        destinationViewController.passDataOnDismiss = { [ weak self ] dataModel in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }

            self.homeScreenView.startAnimating()
            self.homeViewModel.fetchData(for: dataModel.generatedEndpoint) {
                self.homeViewModel.loadBatch {
                    if self.homeViewModel.didFetchNasaData {
                        dataModel.isSearchSuccessful = true
                    }

                    self.homeViewModel.saveSearchToDataBase(with: dataModel)
                    DispatchQueue.main.async {
                        self.homeScreenView.marsPhotosCollectionView.setContentOffset(CGPoint(x: 0, y: -90), animated: true)
                        self.homeScreenView.marsPhotosCollectionView.reloadData()
                        self.homeScreenView.stopAnimating()
                    }
                }
            }
        }
        present(destinationViewController, animated: true)
    }

    @objc private func searchHistoryButtonTapped() {
        let destinationViewController = SearchHistoryViewController()
        destinationViewController.passDataOnDismiss = { [ weak self ] dataModel in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }
            self.homeScreenView.startAnimating()
            self.homeViewModel.fetchData(for: dataModel.generatedEndpoint) {
                self.homeViewModel.loadBatch {
                    DispatchQueue.main.async {
                        self.homeScreenView.marsPhotosCollectionView.setContentOffset(CGPoint(x: 0, y: -90), animated: true)
                        self.homeScreenView.marsPhotosCollectionView.reloadData()
                        self.homeScreenView.stopAnimating()
                    }
                }
            }
        }
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = FullScreenImageViewController()
    let key = NSString(string: homeViewModel.fetchURLString(for: indexPath.row))
        destinationViewController.photo = homeViewModel.cache.object(forKey: key)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarsPhotosCollectionViewCell.identifier, for: indexPath) as! MarsPhotosCollectionViewCell
        cell.imageView.image = homeViewModel.photos[indexPath.row]
        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Since one batch contains 20 photos, we are checking how far did user scroll to decide if we need to load a new one
        let contentHeight: CGFloat = 4000
        let offsetY = scrollView.contentOffset.y - CGFloat((4000 * (homeViewModel.currentPage - 1)))
        let visibleHeight = scrollView.frame.size.height

        if offsetY > contentHeight - visibleHeight - 125 {
            self.homeScreenView.startAnimating()
            homeViewModel.loadBatch {
                DispatchQueue.main.async {
                    self.homeScreenView.marsPhotosCollectionView.reloadData()
                    self.homeScreenView.stopAnimating()
                }
            }
        }
    }
}
