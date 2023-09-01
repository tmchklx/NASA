//
//  TableViewHeader.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

fileprivate struct TableViewSectionHeaderConstraints {
    let stackViewHorizontal: CGFloat = 25
}

final class TableViewSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableViewHeader"
    private let constraint = TableViewSectionHeaderConstraints()
    private let labels = ["Rover:", "Camera:", "Date:"]
    
// MARK: - UI Elements
    let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    func createLabel(with text: String) -> UILabel {
        let label: UILabel = {
            let label = UILabel()
            label.font = FontConstants.boldSubHeader
            label.text = text
            label.textAlignment = .left
            return label
        }()

        return label
    }

// MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        horizontalStackView.topAnchor.constraint(
            equalTo: topAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(
            equalTo: bottomAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: constraint.stackViewHorizontal).isActive = true
        horizontalStackView.trailingAnchor.constraint(
            equalTo: trailingAnchor, constant: -constraint.stackViewHorizontal).isActive = true
    }

// MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorConstants.headerColor
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

// MARK: Setup
    private func buildHierarchy() {
        for index in 0...2 {
            horizontalStackView.addArrangedSubview(createLabel(with: labels[index]))
        }

        addSubview(horizontalStackView)
    }
}

