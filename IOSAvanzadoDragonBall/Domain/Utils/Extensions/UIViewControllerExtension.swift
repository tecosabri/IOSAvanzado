//
//  UIViewControllerExtension.swift
//  IOSAvanzadoDragonBall
//
//  Created by Ismael Sabri Pérez on 7/9/22.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(withTitle title: String, andMessage message: String = "", completion: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func showYesNoAlert(withTitle title: String, andMessage message: String, complete:@escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionYes = UIAlertAction(title: "Sí", style: .default) { _ in
            complete(true)
        }
        let alertActionNo = UIAlertAction(title: "No", style: .default) { _ in
            complete(false)
        }
        alert.addAction(alertActionYes)
        alert.addAction(alertActionNo)
        present(alert, animated: true)
    }
}
