//
//  SearchHistoryViewControllerView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/31/23.
//

import UIKit

final class SearchHistoryViewControllerView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)
        table.register(TableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableViewSectionHeader.identifier)
        table.separatorStyle = .none
        return table
    }()

    let clearHistoryButon: UIButton = {
        let button = UIButton()
        button.setTitle("Clear history", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }

    private func buildHierarchy() {
        addSubview(tableView)
        backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
