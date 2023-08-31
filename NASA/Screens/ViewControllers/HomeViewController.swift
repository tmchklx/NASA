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
    private let homeViewModel: HomeViewModel = HomeViewModel()
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

        let barButton = UIBarButtonItem(customView: homeScreenView.navigationBarButton)
        let currentWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: constants.barButtonSize.width)
        currentWidth?.isActive = true
        let currentHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: constants.barButtonSize.height)
        currentHeight?.isActive = true

        if let appearance = navigationController?.navigationBar.scrollEdgeAppearance {
            appearance.backgroundColor = .white
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

        navigationItem.rightBarButtonItem = barButton
    }

    private func addDelegatesAndTargets() {
        homeScreenView.marsPhotosCollectionView.delegate = self
        homeScreenView.marsPhotosCollectionView.dataSource = self
        homeScreenView.navigationBarButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }

    private func loadDataAtAppLaunch() {
        homeViewModel.fetchData(for: .allRoversCameras(rover: .curiosity, date: "2023-08-01")) {
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
                    self.showAlert()
                }
            }
        }
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "No Date Received",
                                                message: "Seems that selected rover didn't take any pictures with selected options. Try to choose different configuration.",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Handling taps
    @objc private func settingsButtonTapped() {
        let destinationViewController = SettingsViewController()
        destinationViewController.modalPresentationStyle = .popover
        destinationViewController.passDataOnDismiss = { [ weak self ] viewModel in
            guard let self = self else {
                Logger.error("Object seems to be already dealocated.")
                return
            }

            self.homeViewModel.fetchData(for: viewModel.generatedEndpoint) {
                self.homeViewModel.loadBatch {
                    DispatchQueue.main.async {
                        self.homeScreenView.marsPhotosCollectionView.reloadData()
                    }
                }
            }
        }
        present(destinationViewController, animated: true)
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
        let contentHeight: CGFloat = 4000
        let offsetY = scrollView.contentOffset.y - CGFloat((4000 * (homeViewModel.currentPage - 1)))
        let visibleHeight = scrollView.frame.size.height

        if offsetY > contentHeight - visibleHeight {
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
