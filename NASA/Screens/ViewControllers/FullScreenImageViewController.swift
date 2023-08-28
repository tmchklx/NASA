//
//  FullScreenImageViewController.swift
//  NASA
//
//  Created by Oleksandr Tymchenko on 8/27/23.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    private let fullScreenImageView = FullScreenImageView()
    var photo: UIImage? = nil {
        didSet {
            DispatchQueue.main.async {
                self.fullScreenImageView.imageView.image = self.resize(sourceImage: self.photo!, toFitScreen: UIScreen.main.bounds.width)
            }
        }
    }

    override func loadView() {
        view = fullScreenImageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        addTargetsAndDelegates()
    }

    private func addTargetsAndDelegates() {
        fullScreenImageView.scrollView.delegate = self
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        fullScreenImageView.scrollView.addGestureRecognizer(doubleTapGesture)
    }

    private func resize(sourceImage:UIImage, toFitScreen width: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = width / oldWidth

        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if fullScreenImageView.scrollView.zoomScale == fullScreenImageView.scrollView.minimumZoomScale {
            fullScreenImageView.scrollView.setZoomScale(fullScreenImageView.scrollView.maximumZoomScale, animated: true)
        } else {
            fullScreenImageView.scrollView.setZoomScale(fullScreenImageView.scrollView.minimumZoomScale, animated: true)
        }
    }
}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImageView.imageView
    }
}
