//
//  Color.swift
//  Hesabdar
//
//  Created by Pouya on 8/13/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import Foundation
import UIKit

class Color {
    func blue() -> UIColor {
        return UIColor(red: 0/255, green: 126/255, blue: 217/255, alpha: 1)
    }
    func font(size: CGFloat) -> Dictionary<String,Any> {
        let font = UIFont(name: "IRANSans(FaNum)", size: size)!
        return [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.white]
    }
}
