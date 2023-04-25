//
//  Extensions.swift
//  Jodel-iOS-Challange
//
//  Created by Ufuk Anıl Özlük on 25.04.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)
    }
}
