//
//  SearchHistoryCell.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

fileprivate struct SearchHistoryCellConstraints {
    let containerViewHorizontal: CGFloat = 5
    let containerViewTopAnchor: CGFloat = 10
    let containerViewHeight: CGFloat = 50
    let horizontalStackViewHorizontal: CGFloat = 20
}

final class SearchHistoryCell: UITableViewCell {
    static let identifier = "SearchHistoryCell"
    private let constraint = SearchHistoryCellConstraints()
    
// MARK: - UI Elements
    private let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
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

// MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: constraint.containerViewTopAnchor).isActive = true
        containerView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: constraint.containerViewHorizontal).isActive = true
        containerView.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -constraint.containerViewHorizontal).isActive = true
        containerView.bottomAnchor.constraint(
            equalTo: containerView.topAnchor,
            constant: constraint.containerViewHeight).isActive = true

        horizontalStackView.topAnchor.constraint(
            equalTo: containerView.topAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: constraint.horizontalStackViewHorizontal).isActive = true
        horizontalStackView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant:  -constraint.horizontalStackViewHorizontal).isActive = true
        horizontalStackView.bottomAnchor.constraint(
            equalTo: containerView.bottomAnchor).isActive = true
    }
// MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildHierarchy()
    }

// MARK: - Cell setup
    func configureCell(_ model: RequestDataModel) {
        horizontalStackView.addArrangedSubview(createLabel(withText: model.rover.rawValue.capitalized))
        horizontalStackView.addArrangedSubview(createLabel(withText: model.camera.rawValue))
        horizontalStackView.addArrangedSubview(createLabel(withText: model.date))

        if model.isSearchSuccessful {
            containerView.backgroundColor = ColorConstants.successfulSearchCell
        } else {
            containerView.backgroundColor = ColorConstants.unsuccessfulSearchCell
        }
    }

    private func buildHierarchy() {
        containerView.addSubview(horizontalStackView)
        addSubview(containerView)
    }
}

