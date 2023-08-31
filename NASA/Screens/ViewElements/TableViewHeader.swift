//
//  TableViewHeader.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

final class TableViewSectionHeader: UITableViewHeaderFooterView {
    static let identifier = "TableViewHeader"
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

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorConstants.headerColor
        buildHierarchy()
    }

    private func buildHierarchy() {
        horizontalStackView.addArrangedSubview(createLabel(with: "Rover:"))
        horizontalStackView.addArrangedSubview(createLabel(with: "Camera:"))
        horizontalStackView.addArrangedSubview(createLabel(with: "Date:"))
        addSubview(horizontalStackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        horizontalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

