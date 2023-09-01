//
//  SettingsViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

fileprivate struct SettingsViewControllerConstants {
    let headerHeight: CGFloat = 30
    let cellHeight: CGFloat = 40
    let cellPadding: CGFloat = 20
    let interItemSpacing: CGFloat = 7
}

final class SettingsViewController: UIViewController {
    private let settingsView = SettingsViewControllerView()
    private let viewModel = RequestDataModel()
    private let constants = SettingsViewControllerConstants()

    var passDataOnDismiss: ((RequestDataModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetsAndDelegates()
    }

    override func loadView() {
        super.loadView()
        view = settingsView
    }

    private func addTargetsAndDelegates() {
        settingsView.settingsOptionsCollectionView.delegate = self
        settingsView.applySelectionButton.addTarget(
            self,
            action: #selector(applySettings),
            for: .touchUpInside
        )

        settingsView.datePicker.addTarget(
            self,
            action: #selector(selectDate(_:)),
            for: .valueChanged
        )
    }

// MARK: - Selectors
    @objc func applySettings() {
        viewModel.camera = PersistantSettings.shared.camera
        viewModel.rover = PersistantSettings.shared.rover
        viewModel.date = PersistantSettings.shared.date
        passDataOnDismiss?(
            viewModel
        )
        
        dismiss(animated: true)
    }

    @objc func selectDate(_ sender: UIDatePicker) {
        PersistantSettings.shared.date = sender.date.convertToString
    }
}

//MARK: - UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            settingsView.selectedCells.previousRover = settingsView.selectedCells.rover
            settingsView.selectedCells.rover = indexPath
        } else {
            settingsView.selectedCells.previousCamera = settingsView.selectedCells.camera
            settingsView.selectedCells.camera = indexPath
        }

        settingsView.diselectPreviousCellAndSelectCurrent(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let text = Rover.allCases[indexPath.row].rawValue
            let cellWidth = text.size(withAttributes: [.font: FontConstants.cell]).width + constants.cellPadding
            return CGSize(width: cellWidth, height: constants.cellHeight)
        } else {
            let text = Camera.allCases[indexPath.row].rawValue
            let cellWidth = text.size(withAttributes: [.font: FontConstants.cell]).width + constants.cellPadding
            return CGSize(width: cellWidth, height: constants.cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return constants.interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: settingsView.frame.size.width, height: constants.headerHeight)
    }
}
