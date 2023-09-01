//
//  SearchHistoryCell.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

final class SearchHistoryCell: UITableViewCell {
    static let identifier = "SearchHistoryCell"

    private let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
//        container.backgroundColor = ColorConstants.searchHistoryCellBackground
        return container
    }()

    private let horizontalStackView: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alignment = .center
        return container
    }()

    private func createLabel(withText text: String) -> UILabel {
        return {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.textAlignment = .left
            return label
        }()
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true

        horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -20).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    private func buildHierarchy() {
        containerView.addSubview(horizontalStackView)
        addSubview(containerView)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierarchy()
    }

    func configureCell(_ model: RequestDataModel) {
        horizontalStackView.addArrangedSubview(createLabel(withText: model.rover.rawValue))
        horizontalStackView.addArrangedSubview(createLabel(withText: model.camera.rawValue))
        horizontalStackView.addArrangedSubview(createLabel(withText: model.date))

        if model.isSearchSuccessful {
            containerView.backgroundColor = ColorConstants.successfulSearchCell
        } else {
            containerView.backgroundColor = ColorConstants.unsuccessfulSearchCell
        }
    }
}

