//
//  Alerts.swift
//  DiveLane
//
//  Created by Anton Grigorev on 08/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit

func showErrorAlert(for viewController: UIViewController, error: Error?) {
    var text: String?
    if let error = error as? TransactionErrors {
        text = error.rawValue
    }
    let alert = UIAlertController(title: "Error", message: text ?? error?.localizedDescription, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    viewController.present(alert, animated: true, completion: nil)
}

func showSuccessAlert(for viewController: UIViewController, completion: @escaping () -> ()) {
    let alert = UIAlertController(title: "Success", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        completion()
    }
    alert.addAction(cancelAction)
    viewController.present(alert, animated: true, completion: nil)
}
