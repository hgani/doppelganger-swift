//
//  UIKit+NIDoppelganger.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import UIKit

extension UICollectionView {
  func ni_applyBatchChangesForRows(_ array: [NIArrayDiff], inSection section: Int, completion: (()->())? = nil) {
    var insertion = [IndexPath]()
    var deletion = [IndexPath]()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .some(.delete):
        deletion.append(IndexPath(row: obj.previousIndex!, section: section))
      case .some(.insert):
        insertion.append(IndexPath(row: obj.currentIndex!, section: section))
      case .some(.move):
        moving.append(obj)
      default:
        break
      }
    }
    
    performBatchUpdates({ 
      self.insertItems(at: insertion)
      self.deleteItems(at: deletion)
      for obj in moving {
        self.moveItem(at: IndexPath(row: obj.previousIndex!, section: section),
          to: IndexPath(row: obj.currentIndex!, section: section))
      }
      }) { (finished) in
        completion?()
    }
  }
  
  func ni_applyBatchChangesForSections(_ array: [NIArrayDiff], completion: (()->())? = nil) {
    let insertion = NSMutableIndexSet()
    let deletion = NSMutableIndexSet()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .some(.delete):
        deletion.add(obj.previousIndex!)
      case .some(.insert):
        insertion.add(obj.currentIndex!)
      case .some(.move):
        moving.append(obj)
      default:
        break
      }
    }
    
    performBatchUpdates({
      self.insertSections(insertion as IndexSet)
      self.deleteSections(deletion as IndexSet)
      for obj in moving {
        self.moveSection(obj.previousIndex!,toSection: obj.currentIndex!)
      }
    }) { (finished) in
      completion?()
    }
  }
}

extension UITableView {
  func ni_applyBatchChangesForRows(_ array: [NIArrayDiff], inSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
    var insertion = [IndexPath]()
    var deletion = [IndexPath]()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .some(.delete):
        deletion.append(IndexPath(row: obj.previousIndex!, section: section))
      case .some(.insert):
        insertion.append(IndexPath(row: obj.currentIndex!, section: section))
      case .some(.move):
        moving.append(obj)
      default:
        break
      }
    }
    
    beginUpdates()
    deleteRows(at: deletion, with: animation)
    insertRows(at: insertion, with: animation)
    for obj in moving {
      moveRow(at: IndexPath(row: obj.previousIndex!, section: section), to: IndexPath(row: obj.currentIndex!, section: section))
    }
    endUpdates()
  }
  
  func ni_applyBatchChangesForSections(_ array: [NIArrayDiff], withRowAnimation animation: UITableViewRowAnimation) {
    let insertion = NSMutableIndexSet()
    let deletion = NSMutableIndexSet()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .some(.delete):
        deletion.add(obj.previousIndex!)
      case .some(.insert):
        insertion.add(obj.currentIndex!)
      case .some(.move):
        moving.append(obj)
      default:
        break
      }
    }
    
    beginUpdates()
    deleteSections(deletion as IndexSet, with: animation)
    insertSections(insertion as IndexSet, with: animation)
    for obj in moving {
       self.moveSection(obj.previousIndex!,toSection: obj.currentIndex!)
    }
    endUpdates()
  }
}
