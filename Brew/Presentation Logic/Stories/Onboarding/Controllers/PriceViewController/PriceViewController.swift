//
//  PriceViewController.swift
//  Brew
//
//  Created by Vasyl Khmil on 1/22/19.
//  Copyright © 2019 NerdzLab. All rights reserved.
//

import UIKit

class PriceViewController: AppViewController {
    enum PriceOption {
        case small, medium, high
    }

    var onLaterTapped: (() -> Void)?
    var onPurchase: ((PriceOption) -> Void)?

    private(set) var currentOption: PriceOption = .high

    @IBOutlet private var fiveButton: PriceButton!
    @IBOutlet private var tenButton: PriceButton!
    @IBOutlet private var fifteenButton: PriceButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectOption(currentOption)
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
    
    //MARK: - Action
    @IBAction private func fiveSelected() {
        selectOption(.small)
    }
    @IBAction private func tenSelected() {
        selectOption(.medium)
    }
    @IBAction private func fifteenTapped() {
        selectOption(.high)
    }
    
    @IBAction private func nextTapped() {
        onPurchase?(currentOption)
    }

    @IBAction private func laterTapped() {
        onLaterTapped?()
    }

    private func selectOption(_ option: PriceOption) {
        switch option {
        case .small: selectButton(fiveButton)
        case .medium: selectButton(tenButton)
        case .high: selectButton(fifteenButton)
        }

        currentOption = option
    }

    private func selectButton(_ button: PriceButton) {
        fiveButton.isChoosen = button == fiveButton
        tenButton.isChoosen = button == tenButton
        fifteenButton.isChoosen = button == fifteenButton
    }
}

class PriceButton: UIButton {

    var isChoosen: Bool = false {
        didSet {
            backgroundColor = isChoosen ? .appOrange : .white
            let titleColor: UIColor = isChoosen ? .white : .black
            setTitleColor(titleColor, for: .normal)
            layer.borderWidth = isChoosen ? 0 : 1
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        layer.cornerRadius = 36
    }
}
