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

    let rootController: UIViewController

    private lazy var uuid = UUID().uuidString

    init(rootController: UIViewController) {
        self.rootController = rootController
    }

    func start() {
        Coordinator.coordonators[uuid] = self
    }

    func end() {
        Coordinator.coordonators.removeValue(forKey: uuid)
    }
}
