//
//  LoadingViewTestController.swift
//  ADLoadingViewSample
//
//  Created by Samuel Gallet on 15/06/16.
//
//

import UIKit
import ADLoadingView

class LoadingViewTestController: UIViewController {
    var loadingViewStyle: ADLoadingViewStyle = .alert
    private var container : UIView = UIView()
    private var button : UIButton!
    private var loadingViewDisplayed : Bool = false

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.lightGray
        view.addSubview(container)
        let views = ["container" : container]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: .alignAllLeft, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]-(100)-|", options: .alignAllLeft, metrics: nil, views: views))
        button = UIButton();
        button.setTitle("Dismiss", for: UIControlState())
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.addTarget(self, action: #selector(toggleButtonState), for: .touchUpInside)
        container.ad_presentModalLoadingView(withTitle: "Loading", usingAnimation: true, loadingViewStyle: loadingViewStyle)
        loadingViewDisplayed = true
        view.addSubview(button)
        view.addConstraint(NSLayoutConstraint(item: view,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: button,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 1.0))
        view.addConstraint(NSLayoutConstraint(item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: button,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 60.0))
        button.addConstraint(NSLayoutConstraint(item: button,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 32.0))
        button.addConstraint(NSLayoutConstraint(item: button,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 80.0))
    }

    // MARK: Private
    @objc private func toggleButtonState() {
        loadingViewDisplayed = !loadingViewDisplayed
        if loadingViewDisplayed {
            container.ad_presentModalLoadingView(withTitle: "Loading", usingAnimation: true, loadingViewStyle: loadingViewStyle)
        } else {
            container.ad_dismissModalLoadingView(true)
        }
        let buttonTitle = loadingViewDisplayed ? "Dismiss" : "Show"
        button.setTitle(buttonTitle, for: UIControlState())
        view.bringSubview(toFront: button)
    }
}
