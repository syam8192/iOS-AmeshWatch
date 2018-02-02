//
//  ViewController.swift
//  AmeshWatch
//
//  Created by 山上 忍 on 2018/01/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapBaseView: UIView!
    @IBOutlet weak var mapBGImageView: UIImageView!
    @IBOutlet weak var mapInfoImageView: UIImageView!
    @IBOutlet weak var ameshImageView: UIImageView!

    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var selectedAreaView: UIView!
    @IBOutlet weak var frameTopView: UIView!
    @IBOutlet weak var frameLeftView: UIView!
    @IBOutlet weak var frameRightView: UIView!
    @IBOutlet weak var frameBottomView: UIView!
    
    
    var mapSize: CGSize = CGSize.zero {
        didSet{
            setupScrollView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        selectedAreaView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        selectedAreaView.layer.borderWidth = 1

        updateNow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
    }
    
    
    private func updateNow() {
        guard let ameshURL: URL = AmeshAPI().url(for: Date().addingTimeInterval(-60.0)) else { return }
        ImageLoader.shared.load(with: AmeshAPI.mapBGURL) { [weak self] image in
            DispatchQueue.main.async {
                if let image: UIImage = image {
                    self?.mapSize = image.size
                }
                self?.mapBGImageView.image = image
            }
        }
        ImageLoader.shared.load(with: AmeshAPI.mapInfoURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.mapInfoImageView.image = image
            }
        }
        ImageLoader.shared.load(with: ameshURL) { [weak self] image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self?.ameshImageView.image = image
            }
        }
    }

    
    private func setupScrollView() {
        if mapSize.width > 0 {

            scrollView.minimumZoomScale = selectedAreaView.frame.size.width / mapSize.width
            scrollView.maximumZoomScale = scrollView.minimumZoomScale * 8

            mapWidthConstraint.constant = mapSize.width
            mapHeightConstraint.constant = mapSize.height
            adjustScrollViewInsets()
        }
    }
    
    fileprivate func adjustScrollViewInsets() {
        let additionalInsetY =  max((selectedAreaView.frame.height - mapSize.height * scrollView.zoomScale) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: frameTopView.frame.height + additionalInsetY,
                                               left: frameLeftView.frame.width,
                                               bottom: scrollView.frame.height - selectedAreaView.frame.maxY + additionalInsetY,
                                               right: scrollView.frame.width - selectedAreaView.frame.maxX)
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
}

extension ViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapBaseView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustScrollViewInsets()
    }

}


