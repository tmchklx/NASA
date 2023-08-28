//
//  FullScreenImageView.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/28/23.
//

import UIKit

final class FullScreenImageView: UIView {
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.maximumZoomScale = 3.0
        scroll.minimumZoomScale = 1.0
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }

    private func buildHierarchy() {
        scrollView.addSubview(imageView)
        addSubview(scrollView)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildHierarchy()
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
