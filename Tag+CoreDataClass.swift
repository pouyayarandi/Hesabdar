//
//  Tag+CoreDataClass.swift
//  Hesabdar
//
//  Created by Pouya on 8/12/17.
//  Copyright © 2017 Pouya. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Tag: NSManagedObject {
    func setColor(color: UIColor) {
        var _red: CGFloat = 0
        var _green: CGFloat = 0
        var _blue: CGFloat = 0
        var _alpha: CGFloat = 0
        
        color.getRed(&_red, green: &_green, blue: &_blue, alpha: &_alpha)
        
        self.red = Float(_red)
        self.green = Float(_green)
        self.blue = Float(_blue)
    }
    
    func getColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
