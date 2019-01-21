//
//  UIViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/21/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

// topController property return the highest controller in hierarchy that might be visible.
// Is useful in case you need the correct controller for presentation of your content.
// It enumerate through UITabBarControllers, UINavigationControllers & presented UIViewController

extension UIViewController {

    @objc var topController: UIViewController {
        return topViewController(from: self) ?? self
    }

    fileprivate func topViewController(from rootViewController: UIViewController?) -> UIViewController? {

        if let presentedVC = rootViewController?.presentedViewController {
            return topViewController(from: presentedVC)
        }
        else if let navigationVC = rootViewController as? UINavigationController {
            return topViewController(from: navigationVC.topViewController)
        }
        else if let childVC = rootViewController?.children.first {
            return topViewController(from: childVC)
        }
        else {
            return rootViewController
        }
    }
}
