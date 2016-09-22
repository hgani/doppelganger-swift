//
//  NIArrayDiffUtility.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import Foundation

class NIArrayDiffUtility<T :Hashable> {
  
  fileprivate(set) var previousArray: [T]?
  fileprivate(set) var currentArray: [T]?
  
  fileprivate(set) var diff: [NIArrayDiff]?
  
  class func diffForCurrentArray(_ currentArray: [T], previousArray: [T]) -> [NIArrayDiff]? {
    let utility = NIArrayDiffUtility(currentArray: currentArray, previousArray: previousArray)
    utility.performDiff()
    return utility.diff
  }
  
  init(currentArray: [T], previousArray: [T]) {
    self.previousArray = previousArray
    self.currentArray = currentArray
  }
  
  fileprivate func performDiff(){
    guard let previousArray = previousArray else {
      print("NIArrayDiffUtility -> previousArray in performDiff is nil")
      return
    }
    
    guard let currentArray = currentArray else {
      print("NIArrayDiffUtility -> currentArray in performDiff is nil")
      return
    }
    
    let previousSet = Set(previousArray)
    let currentSet = Set(currentArray)
    print("previousSet : \(previousSet)")
    print("currentSet : \(currentSet)")
    
    let deletedObjects = previousSet.subtracting(currentSet)
    let insertedObjects = currentSet.subtracting(previousSet)
    print("deletedObjects : \(deletedObjects)")
    print("insertedObjects : \(insertedObjects)")
    
    let moveDiffs = moveDiffsWithDeletedObjects(deletedObjects, insertedObjects: insertedObjects)
    let deletionDiffs = deletionsForArray(previousArray, deletedObjects: deletedObjects)
    let insertionDiffs = insertionsForArray(currentArray, insertedObjects: insertedObjects)
    
    var results = [NIArrayDiff]()
    results += deletionDiffs
    results += insertionDiffs
    results += moveDiffs
    
    diff = results
  }
  
  fileprivate func deletionsForArray(_ array: [T], deletedObjects: Set<T>) -> [NIArrayDiff] {
    var result = [NIArrayDiff]()
    for (index, obj) in array.enumerated() {
      if !deletedObjects.contains(obj) {
        continue
      }
      result.append(NIArrayDiff.arrayDiffForDeletionAtIndex(index))
    }
    return result
  }
  
  fileprivate func insertionsForArray(_ array: [T], insertedObjects: Set<T>) -> [NIArrayDiff] {
    var result = [NIArrayDiff]()
    for (index, obj) in array.enumerated() {
      if !insertedObjects.contains(obj) {
        continue
      }
      result.append(NIArrayDiff.arrayDiffForInsertionAtIndex(index))
    }
    return result
  }
  
  fileprivate func moveDiffsWithDeletedObjects(_ deletedObjects: Set<T>, insertedObjects: Set<T>) -> [NIArrayDiff] {
    var delta = 0
    var result = [NIArrayDiff]()
    
    guard let previousArray = previousArray else {
      print("NIArrayDiffUtility -> previousArray in moveDiffsWithDeletedObjects is nil")
      return result
    }
    
    guard let currentArray = currentArray else {
      print("NIArrayDiffUtility -> currentArray in moveDiffsWithDeletedObjects is nil")
      return result
    }
    
    for (indexPrevious, objPrevious) in previousArray.enumerated() {
      if deletedObjects.contains(objPrevious) {
        delta += 1
        continue
      }
      
      var localDelta = delta
      for (indexCurrent, objCurrent) in currentArray.enumerated() {
        if insertedObjects.contains(objCurrent) {
          localDelta -= 1
          continue
        }
        if objCurrent != objPrevious {
          continue
        }
        let adjustedIndexCurrent = indexCurrent + localDelta
        if indexPrevious != indexCurrent && adjustedIndexCurrent != indexPrevious {
          result.append(NIArrayDiff.arrayDiffForMoveFromIndex(indexPrevious, toIndex: indexCurrent))
        }
        break
      }
    }
    
    return result
  }
  
}
