//
//  SettingsViewControllerView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

fileprivate struct SettingViewControllerViewConstraints {
    let applyButtonHeight: CGFloat = 44
    let applyButtonInsets: CGFloat = 50
    let sectionInset: CGFloat = 10
    let commonInset: CGFloat = 5
}

//MARK: - SettingsViewIndices
struct SettingsViewIndices {
    var rover: IndexPath = IndexPath(item: PersistantSettings.shared.roverIndex, section: 0) {
        didSet {
            PersistantSettings.shared.rover = Rover.allCases[rover.row]
        }
    }
    var camera: IndexPath = IndexPath(item: PersistantSettings.shared.cameraIndex, section: 1) {
        didSet {
            PersistantSettings.shared.camera = Camera.allCases[camera.row]
        }
    }
    var previousRover: IndexPath? = nil
    var previousCamera: IndexPath? = nil
}

final class SettingsViewControllerView: UIView {
    var selectedCells = SettingsViewIndices()
    private let contraint = SettingViewControllerViewConstraints()

    // MARK: - UI elements initialization
    let applySelectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .link
        return button
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.date = PersistantSettings.shared.date.convertToDate ?? Date()
        return picker
    }()

    let pickDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick date:"
        label.font = FontConstants.boldHeader
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var settingsOptionsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(
            SettingsOptionCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingsOptionCollectionViewCell.identifier
        )

        collection.register(
            CollectionViewSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewSectionHeader.identifier
        )
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private lazy var layout: AlignedCollectionViewFlowLayout = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .leading)
        layout.minimumLineSpacing = contraint.commonInset
        layout.minimumInteritemSpacing = contraint.commonInset
        layout.sectionInset = UIEdgeInsets(top: contraint.sectionInset, left: 0, bottom: 0, right: 0)
        return layout
    }()

    // MARK: - Views layout
    override func layoutSubviews() {
        super.layoutSubviews()
        pickDateLabel.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor,
            constant: contraint.commonInset).isActive = true
        pickDateLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: contraint.commonInset).isActive = true

        datePicker.topAnchor.constraint(
            equalTo: pickDateLabel.bottomAnchor,
            constant: contraint.sectionInset).isActive = true
        datePicker.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: contraint.commonInset).isActive = true

        settingsOptionsCollectionView.topAnchor.constraint(
            equalTo: datePicker.bottomAnchor,
            constant: contraint.sectionInset).isActive = true
        settingsOptionsCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant:  contraint.commonInset).isActive = true
        settingsOptionsCollectionView.bottomAnchor.constraint(
            equalTo: applySelectionButton.topAnchor,
            constant: -contraint.sectionInset).isActive = true
        settingsOptionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        applySelectionButton.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -contraint.applyButtonInsets).isActive = true
        applySelectionButton.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: contraint.applyButtonInsets).isActive = true
        applySelectionButton.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -contraint.applyButtonInsets).isActive = true
        applySelectionButton.topAnchor.constraint(
            equalTo: applySelectionButton.bottomAnchor,
            constant: -contraint.applyButtonHeight).isActive = true
    }
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        addTargetsAndDelegates()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Initial setup
    private func addTargetsAndDelegates() {
        settingsOptionsCollectionView.dataSource = self
    }

    private func buildHierarchy() {
        addSubview(pickDateLabel)
        addSubview(datePicker)
        addSubview(settingsOptionsCollectionView)
        addSubview(applySelectionButton)
    }

// MARK: - selecting and deselecting cells
    private func selectCell(ofIndexPath path: IndexPath) {
        if path.section == 0 {
            let currentCell = settingsOptionsCollectionView.cellForItem(at: selectedCells.rover) as? SettingsOptionCollectionViewCell
            guard let currentCell = currentCell else { return }
            currentCell.wasTapped = true
        } else {
            let currentCell = settingsOptionsCollectionView.cellForItem(at: selectedCells.camera) as? SettingsOptionCollectionViewCell
            guard let currentCell = currentCell else { return }
            currentCell.wasTapped = true
        }
    }

    private func deselectPreviousCell(ofIndexPath path: IndexPath) {
        if path.section == 0 {
            if let index = selectedCells.previousRover {
                let previousCell = settingsOptionsCollectionView.cellForItem(at: index) as? SettingsOptionCollectionViewCell
                guard let previousCell = previousCell else { return }
                previousCell.wasTapped = false
            }
        } else {
            if let index = selectedCells.previousCamera {
                let previousCell = settingsOptionsCollectionView.cellForItem(at: index) as? SettingsOptionCollectionViewCell
                guard let previousCell = previousCell else { return }
                previousCell.wasTapped = false
            }
        }
    }

    func diselectPreviousCellAndSelectCurrent(at index: IndexPath) {
        deselectPreviousCell(ofIndexPath: index)
        selectCell(ofIndexPath: index)
    }
}

// MARK: - UICollectionViewDataSource
extension SettingsViewControllerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return Rover.itemCount
        } else {
            return Camera.itemCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsOptionCollectionViewCell.identifier, for: indexPath) as! SettingsOptionCollectionViewCell
        if indexPath.section == 0 {
            cell.configureCell(name: Rover.allCases[indexPath.row].rawValue)
        } else {
            cell.configureCell(name:  Camera.allCases[indexPath.row].rawValue)
        }

        if selectedCells.rover == indexPath {
            cell.wasTapped = true
        }

        if selectedCells.camera == indexPath {
            cell.wasTapped = true
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewSectionHeader.identifier,
            for: indexPath) as! CollectionViewSectionHeader

        if indexPath.section == 0 {
            header.title.text = "Pick rover:"
        } else {
            header.title.text = "Pick camera:"
        }

        return header
    }
}
