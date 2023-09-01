//
//  SearchHistoryViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

final class SearchHistoryViewController: UIViewController {
    private let searchHistoryView = SearchHistoryViewControllerView()
    private let searchHistoryViewModel = SearchHistoryTableViewModel()
    var passDataOnDismiss: ((RequestDataModel) -> Void)?

    override func loadView() {
        super.loadView()
        view = searchHistoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegatesAndTargets()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = "History"
        let barButton = UIBarButtonItem(customView: searchHistoryView.clearHistoryButon)
        navigationItem.rightBarButtonItem = barButton
    }

    private func addDelegatesAndTargets() {
        searchHistoryView.tableView.delegate = self
        searchHistoryView.tableView.dataSource = self
        searchHistoryView.clearHistoryButon.addTarget(
            self,
            action: #selector(clearHistoryButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func clearHistoryButtonTapped() {
        searchHistoryViewModel.clearHistory()
        searchHistoryView.tableView.reloadData()
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "No Date Received",
                                                message: "Rover didn't take any photos with selected options.",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension SearchHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryViewModel.history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.identifier) as! SearchHistoryCell
        let model = RequestDataModel(
            rover: searchHistoryViewModel.history[indexPath.row].rover,
            camera: searchHistoryViewModel.history[indexPath.row].camera,
            date: searchHistoryViewModel.history[indexPath.row].date,
            isSearchSuccessful: searchHistoryViewModel.history[indexPath.row].isSearchSuccessful)
        cell.configureCell(model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeader")

        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

// MARK: - UITableViewDelegate
extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchQuery = searchHistoryViewModel.history[indexPath.row]

        if searchQuery.isSearchSuccessful {
            let model = RequestDataModel(
                rover: searchQuery.rover,
                camera: searchQuery.camera,
                date: searchQuery.date
            )

            passDataOnDismiss?(model)

            if let navigationController = navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        } else {
            showAlert()
        }
    }
}
