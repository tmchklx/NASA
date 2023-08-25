//
//  SettingsViewControllerView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

final class SettingsViewControllerView: UIView {
    var indexOfSelectedRover: IndexPath = IndexPath(item: 0, section: 0)
    private var indexOfPreviouslySelectedRover: IndexPath?

    var indexOfSelectedCamera: IndexPath = IndexPath(item: 0, section: 1)
    private var indexOfPreviouslySelectedCamera: IndexPath?

    let applySelectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .link
        return button
    }()

    lazy var settingsOptionsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SettingsOptionCollectionViewCell.self,
                            forCellWithReuseIdentifier: SettingsOptionCollectionViewCell.identifier
        )

        collection.register(CollectionViewSectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CollectionViewSectionHeader.identifier
        )
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private lazy var layout: AlignedCollectionViewFlowLayout = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .leading)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: 44)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return layout
    }()

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let pickDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick date:"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func addDelegatesAndDataSources() {
        settingsOptionsCollectionView.dataSource = self
        settingsOptionsCollectionView.delegate = self
        datePicker.addTarget(self, action: #selector(selectDate(_:)), for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        settingsOptionsCollectionView.topAnchor.constraint(equalTo: datePicker.bottomAnchor,constant: 5).isActive = true
        settingsOptionsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor ,constant:  5).isActive = true
        settingsOptionsCollectionView.bottomAnchor.constraint(equalTo: applySelectionButton.topAnchor, constant: -20).isActive = true
        settingsOptionsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        applySelectionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        applySelectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100).isActive = true
        applySelectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
        applySelectionButton.topAnchor.constraint(equalTo: applySelectionButton.bottomAnchor, constant: -44).isActive = true

        datePicker.topAnchor.constraint(equalTo: pickDateLabel.bottomAnchor, constant: 5).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true

        pickDateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        pickDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    }

    func buildHierarchy() {
        addSubview(settingsOptionsCollectionView)
        addSubview(applySelectionButton)
        addSubview(datePicker)
        addSubview(pickDateLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        addDelegatesAndDataSources()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func selectCell(_ isSectionOne: Bool) {
        if isSectionOne {
            let currentCell = settingsOptionsCollectionView.cellForItem(at: indexOfSelectedRover) as? SettingsOptionCollectionViewCell
            guard let currentCell = currentCell else { return }
            indexOfPreviouslySelectedRover = indexOfSelectedRover
            currentCell.wasTapped = true
        } else {
            let currentCell = settingsOptionsCollectionView.cellForItem(at: indexOfSelectedCamera) as? SettingsOptionCollectionViewCell
            guard let currentCell = currentCell else { return }
            indexOfPreviouslySelectedCamera = indexOfSelectedCamera
            currentCell.wasTapped = true

        }
    }

    private func diselectPreviousCell(_ sectionOne: Bool) {
        if sectionOne {
            if let index = indexOfPreviouslySelectedRover {
                let previousCell = settingsOptionsCollectionView.cellForItem(at: index) as? SettingsOptionCollectionViewCell
                guard let previousCell = previousCell else { return }
                previousCell.wasTapped = false
            }
        } else {
            if let index = indexOfPreviouslySelectedCamera {
                let previousCell = settingsOptionsCollectionView.cellForItem(at: index) as? SettingsOptionCollectionViewCell
                guard let previousCell = previousCell else { return }
                previousCell.wasTapped = false
            }
        }

    }

    private func diselectPreviousCellAndSelectCurrent(at index: IndexPath) {
        if index.section == 0 {
            diselectPreviousCell(true)
            indexOfSelectedRover = index
            selectCell(true)
        } else {
            diselectPreviousCell(false)
            indexOfSelectedCamera = index
            selectCell(false)
        }
    }

    @objc func selectDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let formattedDate = dateFormatter.string(from: selectedDate)
        Logger.error(formattedDate)
    }
}

extension SettingsViewControllerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let text = Rover.allCases[indexPath.row].rawValue
            let labelWdth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).width + 20
            return CGSize(width: labelWdth, height: 40)
        } else {
            let text =  Camera.allCases[indexPath.row].rawValue
            let labelWdth = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).width + 20
            return CGSize(width: labelWdth, height: 40)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsOptionCollectionViewCell.identifier, for: indexPath) as! SettingsOptionCollectionViewCell
        if indexPath.section == 0 {
            selectCell(true)
            cell.configureCell(name: Rover.allCases[indexPath.row].rawValue)
        } else {
            selectCell(false)
            cell.configureCell(name:  Camera.allCases[indexPath.row].rawValue)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.size.width, height: 30)
    }
}

extension SettingsViewControllerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        diselectPreviousCellAndSelectCurrent(at: indexPath)
    }
}
