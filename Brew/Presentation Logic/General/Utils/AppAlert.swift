//
//  AppAlert.swift
//  NerdzLab
//
//  Created by Vasyl Khmil on 4/10/18.
//  Copyright © 2018 NerdzLab. All rights reserved.
//

import UIKit

// `AppAlert` is a protocol that represent generic application alert
// `AppAlert` is used to hide the full implementation of different kind of alerts and provide limited amount of methods to use. This will save from modifying builded by special builders alert.
// To chech how it works - check `AppAlertBuilder.swift` file that hide system UIAlertController implementation under `AppAlert` protocol.

@objc protocol AppAlert {
    // This method should provide a possibility to show alert after it get complitelly builded by one of builder class.
    func show(from container: UIViewController?)
}

fileprivate extension AppAlertBuilder {
    struct Const {
        struct Numbers {
            static let optimalActionsCount = 2
        }

        struct Strings {
            struct Warnings {
                static let noTitleAndMessage = "A message OR title is required to create an alert"
                static let noActionsForAlertType = "AppAlert requires at least one action for style .alert in order to dismiss"
                static let actionsCountNotOptimal = "User Guidelines suggests keeping actions to \(Const.Numbers.optimalActionsCount)"
                static let cancelButtonIncorrectOrder = "Cancel buttons should always be on the left for alerts according to apple guidelines."
            }
        }
    }
}

extension Error {
    func display(from container: UIViewController? = nil) {
        AppAlertBuilder
            .makeBuilder(with: "Error", message: localizedDescription, style: .alert)
            .cancel(title: "OK")
            .build()?
            .show(from: container)
    }
}

extension NetworkingError {
    func display(from container: UIViewController? = nil) {
        AppAlertBuilder
            .makeBuilder(with: "Error", message: message, style: .alert)
            .cancel(title: "OK")
            .build()?
            .show(from: container)
    }
}

// Adoption of default system `UIAlertController` alert to `VidaAlert` protocol.
// This allow to hide all `UIAlertController` implementation and minimize possibility of changes after `VidaAlertBuilder` will build it.

extension UIAlertController: AppAlert {

    func show(from container: UIViewController? = nil) {
        DispatchQueue.main.async {
            let presenter = container ?? UIApplication.shared.keyWindow?.rootViewController?.topController
            presenter?.present(self, animated: true)
        }
    }
}

// `AppAlertBuilder` is class that follow Builder design patter for building application alert.
// Check methods documentation for better usage understanding.

// Example
// AppAlertBuilder.makeBuilder(with: title, message: message, style: .actionSheet)
//     .action(title: "Action 1")
//     .action(title: "Action 2"){ doSomething() }
//     .destructive(title: "Destructive")
//     .cancel(title: "Cancel")
//     .build()?
//     .show(from: container, source)

// The order you are calling methods `action`, `destructive`, `cancel` matter. In same way buttons on alert will be ordered.

class AppAlertBuilder: NSObject {
    typealias ActionHandler = () -> Void

    // `alertController` is an internal variable of alert that builder are working on.
    fileprivate let alertController: UIAlertController

    // Internal initializer for creating the instance of `AppAlertBuilder`. You should never try to use it outside. For instantiating from outside use static method `instantiate`.

    // :alertController - internal instance of `UIAlertController` that builder will be working on.
    fileprivate init(alertController: UIAlertController) {
        self.alertController = alertController
    }

    // Public function for instantiation of `AppAlertBuilder` class.

    // :title - parameter will be used as a title of alert.
    // :message - parameter will be used as a message of alert.
    // :style - define a style of altert.
    @objc class func makeBuilder(with title: String?, message: String?, style: UIAlertController.Style) -> AppAlertBuilder {

        let internalAlertController = UIAlertController(title: title, message: message, preferredStyle: style)
        return AppAlertBuilder(alertController: internalAlertController)
    }

    // Builder method, that add a button with style `action` to an alert.

    // :title - parameter will be used as a title of a button
    // :handler - closure that will be called on button press

    // return instance of current `AppAlertBuilder` for continuing building
    @discardableResult
    @objc func action(title: String?, handler: ActionHandler? = nil) -> AppAlertBuilder {
        let alertAction = UIAlertAction(title: title, style: .default) { _ in
            handler?()
        }

        alertController.addAction(alertAction)

        return self
    }

    // Builder method, that add a button with style `destructive` to an alert.

    // :title - parameter will be used as a title of a button
    // :handler - closure that will be called on button press

    // return instance of current `AppAlertBuilder` for continuing building
    @discardableResult
    @objc func destructive(title: String?, handler: ActionHandler? = nil) -> AppAlertBuilder {
        let alertAction = UIAlertAction(title: title, style: .destructive) { _ in
            handler?()
        }

        alertController.addAction(alertAction)

        return self
    }

    // Builder method, that add a button with style `cancel` to an alert.

    // :title - parameter will be used as a title of a button
    // :handler - closure that will be called on button press

    // return instance of current `AppAlertBuilder` for continuing building
    @discardableResult
    @objc func cancel(title: String?, handler: ActionHandler? = nil) -> AppAlertBuilder {
        let alertAction = UIAlertAction(title: title, style: .cancel) { _ in
            handler?()
        }

        if alertController.preferredStyle == .alert && !alertController.actions.isEmpty {
            print(Const.Strings.Warnings.cancelButtonIncorrectOrder)
        }

        alertController.addAction(alertAction)

        return self
    }

    // Method is adding a source view that will de used for popover presentation on tablet devices

    // return instance of current `AppAlertBuilder` for continuing building
    @discardableResult
    @objc func source(_ source: UIView) -> AppAlertBuilder {
        alertController.popoverPresentationController?.sourceView = source
        alertController.popoverPresentationController?.sourceRect = source.bounds

        return self
    }

    // Method validate if building is possible and create an alert for displaying.

    // :source - view source to be used in case the alert will be presented as a popover on tablet devices

    // return instance of `AppAlert` if validation passed or `nil` if validation failed
    @objc func build() -> AppAlert? {
        let builderValid = validateBulider()
        return builderValid ? alertController : nil
    }

    // Method validate if alert components are valid for building.

    // return indicator if state is valid
    fileprivate func validateBulider() -> Bool {
        return validateActionsNumber() && validateContent() && validatePopoverSource()
    }

    // Method validate if popover source is valid for `.actionSheet` tablet presentation.

    // return indicator if popover source is valid
    fileprivate func validatePopoverSource() -> Bool {
        if alertController.preferredStyle == .alert {
            return true
        }
        let sourceValid = alertController.preferredStyle == .actionSheet &&
            alertController.popoverPresentationController?.sourceView != nil &&
            alertController.popoverPresentationController?.sourceRect != nil

        let isPad = UIDevice.current.userInterfaceIdiom == .pad

        if !sourceValid {
            // ipads need a popover source fro anction sheets, but is is provided later in the life cycle of the alert
            return !isPad
        }

        return true
    }

    // Method validate if alert actions count is valid for building.

    // return indicator if actions count is valid
    fileprivate func validateActionsNumber() -> Bool {
        var isValid = true

        if alertController.preferredStyle == .alert {
            if alertController.actions.isEmpty {
                print(Const.Strings.Warnings.noActionsForAlertType)
                isValid = false
            }

            if alertController.actions.count > Const.Numbers.optimalActionsCount {
                print(Const.Strings.Warnings.actionsCountNotOptimal)
            }
        }

        return isValid
    }

    // Method validate if alert content is valid for building.

    // return indicator if content is valid
    fileprivate func validateContent() -> Bool  {
        var isValid = true

        if alertController.title == nil &&
            alertController.message == nil &&
            alertController.preferredStyle == .alert {
            print(Const.Strings.Warnings.noTitleAndMessage)
            isValid = false
        }


        return isValid
    }

    // Method assign direction of popover

    // :sourcePosition - parameter will be used as coordinates of source (view that it will be shown on).
    // :sourceSize - parameter will be used as a size of source.
    // :screenSize - parameter will be used as a size of device screen.
    // :alertSize - parameter will be used as a size of alert with default universal size 270 width x 144 height.

    // return direction
    @objc func assignPopoverDirectionBasedUponGivenView(sourcePosition: CGPoint, sourceSize: CGSize, screenSize: CGSize = UIScreen.main.bounds.size, alertSize: CGSize = CGSize(width: 270.0, height: 144.0)) -> UIPopoverArrowDirection {
        var direction: UIPopoverArrowDirection
        let profileX = sourcePosition.x
        let profileY = sourcePosition.y
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let profileHeight = sourceSize.height
        let profileWidth = sourceSize.width
        let alertHeight = alertSize.height
        let alertWidth = alertSize.width
        //arrow direction left when alert extends over left side of screen due to its width in relation to the x position + width of profile icon
        if alertWidth/2 > (profileX + profileWidth/2) {
            direction = UIPopoverArrowDirection.left
        }
            //arrow direction right when alert extends over right side of screen due to its width and x position + width of profile icon
        else if screenWidth < (profileX + profileWidth/2 + alertWidth/2) {
            direction = UIPopoverArrowDirection.right
        }
            //arrow direction down when profile icon's y position and height + alert's height exceed the height of the screen
        else if screenHeight < (profileY + profileHeight + alertHeight) {
            direction = UIPopoverArrowDirection.down
        }
            //default arrow direction up
        else {
            direction = UIPopoverArrowDirection.up

        }
        alertController.popoverPresentationController?.permittedArrowDirections = direction

        return direction
    }

    @discardableResult
    @objc func assignPopoverDirection(sourcePosition: CGPoint, sourceSize: CGSize) -> UIPopoverArrowDirection {
        return self.assignPopoverDirectionBasedUponGivenView(sourcePosition: sourcePosition, sourceSize: sourceSize)
    }
}
