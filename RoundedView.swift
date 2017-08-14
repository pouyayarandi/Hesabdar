//
//  RoundedView.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }

}
