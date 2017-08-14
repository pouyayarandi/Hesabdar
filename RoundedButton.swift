//
//  RoundedButton.swift
//  Hesabdar
//
//  Created by Pouya on 8/14/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
}
