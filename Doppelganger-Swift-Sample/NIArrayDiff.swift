//
//  NIArrayDiff.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import Foundation

enum NIArrayDiffType {
  case Move, Insert, Delete
}

class NIArrayDiff {
  private(set) var type: NIArrayDiffType!
  private(set) var previousIndex: Int?
  private(set) var currentIndex: Int?
  
  static func arrayDiffForDeletionAtIndex(index: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .Delete
    instance.previousIndex = index
    return instance
  }
  
  static func arrayDiffForInsertionAtIndex(index: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .Insert
    instance.currentIndex = index
    return instance
  }
  
  static func arrayDiffForMoveFromIndex(fromIndex: Int, toIndex: Int) -> NIArrayDiff {
    let instance = NIArrayDiff()
    instance.type = .Move
    instance.previousIndex = fromIndex
    instance.currentIndex = toIndex
    return instance
  }
  
  var description: String {
    switch type {
    case .Some(.Move):
      return "<\(NIArrayDiff.self): \(self)> {type=move; from=\(previousIndex); to=\(currentIndex)}"
    case .Some(.Insert):
      return "<\(NIArrayDiff.self): \(self)> {type=insertion; to=\(currentIndex)}"
    case .Some(.Delete):
      return "<\(NIArrayDiff.self): \(self)> {type=move; from=\(previousIndex)}"
    default:
      return ""
    }
    
  }
  
}