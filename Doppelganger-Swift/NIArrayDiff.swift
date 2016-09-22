//
//  NIArrayDiff.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import Foundation

enum NIArrayDiffType {
  case move, insert, delete
}

class NIArrayDiff {
  fileprivate(set) var type: NIArrayDiffType!
  fileprivate(set) var previousIndex: Int?
  fileprivate(set) var currentIndex: Int?
  
  static func arrayDiffForDeletionAtIndex(_ index: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .delete
    instance.previousIndex = index
    return instance
  }
  
  static func arrayDiffForInsertionAtIndex(_ index: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .insert
    instance.currentIndex = index
    return instance
  }
  
  static func arrayDiffForMoveFromIndex(_ fromIndex: Int, toIndex: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .move
    instance.previousIndex = fromIndex
    instance.currentIndex = toIndex
    return instance
  }
  
  var description: String {
    switch type {
    case .some(.move):
      return "<\(NIArrayDiff.self): \(self)> {type=move; from=\(previousIndex); to=\(currentIndex)}"
    case .some(.insert):
      return "<\(NIArrayDiff.self): \(self)> {type=insertion; to=\(currentIndex)}"
    case .some(.delete):
      return "<\(NIArrayDiff.self): \(self)> {type=move; from=\(previousIndex)}"
    default:
      return ""
    }
    
  }
  
}
