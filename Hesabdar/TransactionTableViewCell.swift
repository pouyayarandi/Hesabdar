//
//  TransactionTableViewCell.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    let format = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(transaction: Transaction) {
        self.titleLabel.text = transaction.title
        self.tagLabel.text = transaction.tagName
        self.valueLabel.text = String(Int(transaction.value))
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
}
