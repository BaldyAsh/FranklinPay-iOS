//
//  NetworksCell.swift
//  DiveLane
//
//  Created by Anton Grigorev on 08/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit
import Web3swift

class NetworkCell: UITableViewCell {

    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomBackgroundView.backgroundColor = Colors.firstMain
        self.topBackgroundView.backgroundColor = Colors.secondMain
        self.topBackgroundView.layer.cornerRadius = 10
        self.networkLabel.textColor = Colors.textFirst
        self.networkLabel.textColor = Colors.textSecond
        self.idLabel.textColor = Colors.textFirst
        self.selectedIcon.image = UIImage(named: "added")
    }

    func configure(network: Web3Network, isChosen: Bool = false) {
        self.networkLabel.text = network.name
        self.idLabel.text = "id: \(network.id)"
        self.selectedIcon.alpha = isChosen ? 1.0 : 0.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedIcon.alpha = 0.0
        self.networkLabel.text = ""
        self.idLabel.text = ""
    }

}