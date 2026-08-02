//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим on 22.07.2026.
//

import UIKit

final class ResultAlertPresenter {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = model.accessibilityIdentifier
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
