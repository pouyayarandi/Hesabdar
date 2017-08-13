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
        self.red = Float(color.ciColor.red)
        self.green = Float(color.ciColor.green)
        self.blue = Float(color.ciColor.blue)
    }
    
    func getColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
