//
//  Coordinator.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/23/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class Coordinator {
    private static var coordonators: [String: Coordinator] = [:]

    let contentController: UIViewController

    private lazy var uuid = UUID().uuidString

    init() {
        contentController = AppViewController()
    }

    init(contentController: UIViewController) {
        self.contentController = contentController
    }

    func start() {
        Coordinator.coordonators[uuid] = self
    }

    func end() {
        Coordinator.coordonators.removeValue(forKey: uuid)
    }
}

class NavigationCoordinator: Coordinator {

    var navigationController: UINavigationController? {
        return contentController as? UINavigationController
    }

    override init() {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true

        super.init(contentController: navigationController)
    }
}
