//
//  AlertController.swift
//  taskMap
//
//  Created by Давид Тоноян  on 03.10.2022.
//

import UIKit

final class AlertController {
    static let shared = AlertController()
    var addingAlertController = UIAlertController()
    var errorAlertController = UIAlertController()
    
    func createAddAlertController(title: String,
                                  placeholder: String,
                                  completionHandler: @escaping (String) -> Void) {
        addingAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let alertOkButton = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
            let textField = self?.addingAlertController.textFields?.first
            guard let text = textField?.text else { return }
            completionHandler(text)
        }
        let alertCancelButton = UIAlertAction(title: "Cancel", style: .default)
        addingAlertController.addTextField { textField in
            textField.placeholder = placeholder
        }
        
        addingAlertController.addAction(alertOkButton)
        addingAlertController.addAction(alertCancelButton)
    }
    
    func createErrorAlertController(title: String, message: String) {
        errorAlertController = UIAlertController(title: title,
                                                 message: message,
                                                 preferredStyle: .alert)
        let alertOkButton = UIAlertAction(title: "OK", style: .default)
        errorAlertController.addAction(alertOkButton)
    }
}
