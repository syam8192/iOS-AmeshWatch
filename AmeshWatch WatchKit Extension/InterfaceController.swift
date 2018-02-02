//
//  InterfaceController.swift
//  AmeshWatch WatchKit Extension
//
//  Created by 山上 忍 on 2018/01/22.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var mapBaseGroup: WKInterfaceGroup!
    @IBOutlet var mapBGImageView: WKInterfaceImage!
    @IBOutlet var mapInfoImageView: WKInterfaceImage!
    @IBOutlet var ameshImageView: WKInterfaceImage!
    @IBOutlet var messageLabel: WKInterfaceLabel!
    @IBOutlet var retryButton: WKInterfaceButton!

    private var isCrownRotating: Bool = false

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
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
        showMessage("Loading...")
        ImageLoader.shared.load(with: ameshURL) { [weak self] image in
            guard let image = image else {
                self?.showMessage("取得できませんでした.", retryEnabled: true)
                return
            }
            self?.hideMessage()
            self?.ameshImageView.setImage(image)
        }
    }

    @IBAction func onClickRetryButton() {
        updateNow()
    }
    
    private func hideMessage() {
        mapInfoImageView.setHidden(false)
        mapBGImageView.setHidden(false)
        ameshImageView.setHidden(false)
        messageLabel.setHidden(true)
    }

    private func showMessage(_ message: String, retryEnabled: Bool = false) {
        messageLabel.setText(message)
        mapInfoImageView.setHidden(true)
        mapBGImageView.setHidden(true)
        ameshImageView.setHidden(true)
        messageLabel.setHidden(false)
        retryButton.setHidden(!retryEnabled)
    }

    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        if !isCrownRotating {
            
            if rotationalDelta > 0.3 {
   
                
                
                
//                mapInfoImageView.setVerticalAlignment(.center)
                
            } else if rotationalDelta < -0.3 {
                
                
                
            }
            
            isCrownRotating = true
        }
        
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        isCrownRotating = false
    }
    
}

