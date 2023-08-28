//
//  SettingsOptionCollectionViewCell.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

fileprivate struct SettingOptionCollectionViewCellConstraints {
    let rectangularViewVertical: CGFloat = 6.5
    let rectangularViewHorizontal: CGFloat = 10
}

final class SettingsOptionCollectionViewCell: UICollectionViewCell {
    static let identifier = Identifier.settingOptionCell
    private let constraint = SettingOptionCollectionViewCellConstraints()

    var wasTapped = false {
        willSet {
            if newValue {
                isUserInteractionEnabled = false
                roundedRectangularView.backgroundColor = ColorConstants.selectedSettingOption
            } else {
                isUserInteractionEnabled = true
                roundedRectangularView.backgroundColor = ColorConstants.unselectedSettingOption
            }
        }
    }

// MARK: - Views Initialization
    private let roundedRectangularView: UIView = {
        let button = UIView()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorConstants.unselectedSettingOption
        return button
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

// MARK: - Views layout
    override func layoutSubviews() {
        super.layoutSubviews()

        buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        roundedRectangularView.topAnchor.constraint(
            equalTo: buttonLabel.topAnchor,
            constant: -constraint.rectangularViewVertical).isActive = true
        roundedRectangularView.leadingAnchor.constraint(
            equalTo: buttonLabel.leadingAnchor,
            constant: -constraint.rectangularViewHorizontal).isActive = true
        roundedRectangularView.bottomAnchor.constraint(
            equalTo: buttonLabel.bottomAnchor,
            constant: constraint.rectangularViewVertical).isActive = true
        roundedRectangularView.trailingAnchor.constraint(
            equalTo: buttonLabel.trailingAnchor,
            constant: constraint.rectangularViewHorizontal).isActive = true
    }

// MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
// MARK: - Cell setup
    private func buildHierarchy() {
        addSubview(roundedRectangularView)
        addSubview(buttonLabel)
    }

    func configureCell(name: String) {
        buttonLabel.text = name
    }
}
