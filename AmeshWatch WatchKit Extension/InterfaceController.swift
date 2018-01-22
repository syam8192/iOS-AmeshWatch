//
//  InterfaceController.swift
//  AmeshWatch WatchKit Extension
//
//  Created by 山上 忍 on 2018/01/22.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var mapBGImageView: WKInterfaceImage!
    @IBOutlet var mapInfoImageView: WKInterfaceImage!
    @IBOutlet var ameshImageView: WKInterfaceImage!
    @IBOutlet var messageLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        updateNow()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    private func updateNow() {
        guard let ameshURL: URL = AmeshAPI().url(for: Date().addingTimeInterval(-60.0)) else { return }
        ImageLoader.shared.load(with: AmeshAPI.mapBGURL) { [weak self] image in
            self?.mapBGImageView.setImage(image)
        }
        ImageLoader.shared.load(with: AmeshAPI.mapInfoURL) { [weak self] image in
            self?.mapInfoImageView.setImage(image)
        }
        showError(message: "Loading...")
        ImageLoader.shared.load(with: ameshURL) { [weak self] image in
            guard let image = image else {
                self?.showError(message: "取得できませんでした.")
                return
            }
            self?.hideError()
            self?.ameshImageView.setImage(image)
        }
    }
    
    private func hideError() {
        mapInfoImageView.setHidden(false)
        mapBGImageView.setHidden(false)
        ameshImageView.setHidden(false)
        messageLabel.setHidden(true)
    }
    
    private func showError(message: String) {
        messageLabel.setText(message)
        mapInfoImageView.setHidden(true)
        mapBGImageView.setHidden(true)
        ameshImageView.setHidden(true)
        messageLabel.setHidden(false)
    }

}

