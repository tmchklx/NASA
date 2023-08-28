//
//  CollectionViewSectionHeader.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/25/23.
//

import UIKit

final class CollectionViewSectionHeader: UICollectionReusableView {
    static let identifier = Identifier.sectionHeader
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontConstants.boldHeader
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
    }

    private func buildHierarchy() {
        addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
