//
//  CreateWalletPincodeViewController.swift
//  DiveLane
//
//  Created by Anton Grigorev on 12/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit

class CreateWalletPincodeViewController: PincodeViewController {
    
    var pincode: String = ""
    var repeatedPincode: String = ""
    var status: PincodeCreationStatus = .new
    
    var pincodeItems: [KeychainPasswordItem] = []
    
    let localStorage = LocalDatabase()
    let animation = AnimationController()
    
    //var newWallet: Bool = false
    
    var wallet: KeyWalletModel?
    
    convenience init (forWallet: KeyWalletModel) {
        self.init()
        wallet = forWallet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        biometricsButton.alpha = 0.0
        biometricsButton.isUserInteractionEnabled = false
        changePincodeStatus(.new)
        numsIcons = [firstNum, secondNum, thirdNum, fourthNum]
    }
    
    override func numberPressedAction(number: String) {
        if status == .new {
            pincode += number
            changeNumsIcons(pincode.count)
            if pincode.count == 4 {
                let newStatus: PincodeCreationStatus = .verify
                changePincodeStatus(newStatus)
            }
        } else if status == .verify {
            repeatedPincode += number
            changeNumsIcons(repeatedPincode.count)
            if repeatedPincode.count == 4 {
                let newStatus: PincodeCreationStatus = repeatedPincode == pincode ? .ready : .wrong
                changePincodeStatus(newStatus)
            }
        } else if status == .wrong {
            changePincodeStatus(.verify)
            repeatedPincode += number
            changeNumsIcons(repeatedPincode.count)
        }
    }
    
    override func deletePressedAction() {
        switch status {
        case .new:
            if pincode != "" {
                pincode.removeLast()
                changeNumsIcons(pincode.count)
            }
        default:
            if repeatedPincode != "" {
                repeatedPincode.removeLast()
                changeNumsIcons(repeatedPincode.count)
            }
        }
    }
    
    func changePincodeStatus(_ newStatus: PincodeCreationStatus) {
        status = newStatus
        messageLabel.text = status.rawValue
        if status == .wrong {
            repeatedPincode = ""
            changeNumsIcons(0)
        } else if status == .ready {
            createWallet()
        } else if status == .verify {
            changeNumsIcons(0)
        }
    }
    
    func createWallet() {
        do {
            let pincodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: "THEMATTER",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try pincodeItem.savePassword(pincode)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        UserDefaults.standard.set(true, forKey: "pincodeExists")
        UserDefaults.standard.synchronize()
        
        savingWallet()
    }
    
    func savingWallet() {
        guard let wallet = self.wallet else {
            showErrorAlert(for: self, error: WalletSavingError.couldNotCreateTheWallet)
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.animation.waitAnimation(isEnabled: true,
                                         notificationText: "Saving wallet",
                                         on: (self?.view)!)
        }
        self.localStorage.saveWallet(wallet: wallet) { [weak self] (error) in
            if error == nil {
                print("Wallet imported")
                DispatchQueue.main.async { [weak self] in
                    self?.animation.waitAnimation(isEnabled: false,
                                                  on: (self?.view)!)
                }
                let tabViewController = AppController().goToApp()
                tabViewController.view.backgroundColor = UIColor.white
                self?.present(tabViewController, animated: true, completion: nil)
            } else {
                showErrorAlert(for: self!, error: error)
            }
        }
    }
}
