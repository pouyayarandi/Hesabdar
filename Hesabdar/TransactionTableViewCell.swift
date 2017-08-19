//
//  TransactionTableViewCell.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    let model = Model()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(transaction: Transaction) {
        self.titleLabel.text = transaction.title
        self.tagLabel.text = transaction.tagName
        self.valueLabel.text = model.format().string(from: transaction.value as NSNumber)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
}
