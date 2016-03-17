//
//  RowObject.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import UIKit

class RowObject {
  var color: UIColor
  var title: String
  
  init(color: UIColor, title: String) {
    self.color = color
    self.title = title
  }
  
  class func listOfRowObjects() -> [RowObject] {
    
    func titleForIndex(index: Int) -> String {
      let numberFormatter = NSNumberFormatter()
      numberFormatter.numberStyle = .SpellOutStyle
      
      let number = arc4random_uniform(100)
      let allLocales = NSLocale.availableLocaleIdentifiers()
        .sort { _,_ in number > 50 }
      
      let localeIdentifier = allLocales[index%allLocales.count]
      
      let locale = NSLocale(localeIdentifier: localeIdentifier)
      numberFormatter.locale = locale
      return numberFormatter.stringFromNumber(index)!
    }
    
    func colorForIndex(index: Int) -> UIColor {
      let number = arc4random_uniform(100)
      let colors = [UIColor(red: 0.725, green: 0.212, blue: 0.169, alpha: 1.000),
                    UIColor(red: 0.231, green: 0.694, blue: 0.353, alpha: 1.000),
                    UIColor(red: 0.925, green: 0.624, blue: 0.071, alpha: 1.000),
                    UIColor(red: 0.243, green: 0.490, blue: 0.733, alpha: 1.000),
                    UIColor(red: 0.553, green: 0.208, blue: 0.690, alpha: 1.000),
                    UIColor(red: 0.204, green: 0.635, blue: 0.518, alpha: 1.000),
                    UIColor(red: 0.875, green: 0.282, blue: 0.235, alpha: 1.000),
                    UIColor(red: 0.212, green: 0.635, blue: 0.322, alpha: 1.000),
                    UIColor(red: 0.922, green: 0.784, blue: 0.027, alpha: 1.000),
                    UIColor(red: 0.294, green: 0.573, blue: 0.859, alpha: 1.000),
                    UIColor(red: 0.588, green: 0.290, blue: 0.714, alpha: 1.000),
                    UIColor(red: 0.243, green: 0.745, blue: 0.600, alpha: 1.000)]
        .sort { _,_ in number > 50 }
      
      return colors[index%colors.count]
      
    }
    
    
    var result = [RowObject]()
    let count = Int(arc4random_uniform(5) + 5)
    for i in 0...count {
      result.append(RowObject(color: colorForIndex(i), title: titleForIndex(i)))
    }
    let number = arc4random_uniform(100)
    return result.sort { _,_ in number > 50 }
  }
}

func ==(lhs: RowObject, rhs: RowObject) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

extension RowObject: Hashable {
  
  var hashValue: Int {
    return title.hash
  }
  
  // compability with obj-c
  var hash: Int {
    return title.hash
  }
  
  func isEqual(object: AnyObject?) -> Bool {
    if let object = object as? RowObject {
      return hashValue == object.hashValue
    } else {
      return false
    }
  }

}