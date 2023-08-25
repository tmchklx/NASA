//
//  SettingsOptionCollectionViewCell.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

final class SettingsOptionCollectionViewCell: UICollectionViewCell {
    static let identifier = "settingsOptionCollectionViewCell"

    let button: UIView = {
        let button = UIView()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        return button
    }()

    let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var wasTapped = false {
        willSet {
            if newValue {
                isUserInteractionEnabled = false
                button.backgroundColor = .selectedOption

            } else {
                isUserInteractionEnabled = true
                button.backgroundColor = .unselectedOption
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        button.topAnchor.constraint(equalTo: buttonLabel.topAnchor, constant: -10).isActive = true
        button.leadingAnchor.constraint(equalTo: buttonLabel.leadingAnchor, constant: -10).isActive = true
        button.bottomAnchor.constraint(equalTo: buttonLabel.bottomAnchor, constant: 10).isActive = true
        button.trailingAnchor.constraint(equalTo: buttonLabel.trailingAnchor, constant: 10).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func buildHierarchy() {
        addSubview(button)
        addSubview(buttonLabel)
    }

    func configureCell(name: String) {
        buttonLabel.text = name

    }
}
