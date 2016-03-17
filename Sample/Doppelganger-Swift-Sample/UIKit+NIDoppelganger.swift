//
//  UIKit+NIDoppelganger.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import UIKit

extension UICollectionView {
  func ni_applyBatchChangesForRows(array: [NIArrayDiff], inSection section: Int, completion: (()->())? = nil) {
    var insertion = [NSIndexPath]()
    var deletion = [NSIndexPath]()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .Some(.Delete):
        deletion.append(NSIndexPath(forRow: obj.previousIndex!, inSection: section))
      case .Some(.Insert):
        insertion.append(NSIndexPath(forRow: obj.currentIndex!, inSection: section))
      case .Some(.Move):
        moving.append(obj)
      default:
        break
      }
    }
    
    performBatchUpdates({ 
      self.insertItemsAtIndexPaths(insertion)
      self.deleteItemsAtIndexPaths(deletion)
      for obj in moving {
        self.moveItemAtIndexPath(NSIndexPath(forRow: obj.previousIndex!, inSection: section),
          toIndexPath: NSIndexPath(forRow: obj.currentIndex!, inSection: section))
      }
      }) { (finished) in
        completion?()
    }
  }
  
  func ni_applyBatchChangesForSections(array: [NIArrayDiff], completion: (()->())? = nil) {
    let insertion = NSMutableIndexSet()
    let deletion = NSMutableIndexSet()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .Some(.Delete):
        deletion.addIndex(obj.previousIndex!)
      case .Some(.Insert):
        insertion.addIndex(obj.currentIndex!)
      case .Some(.Move):
        moving.append(obj)
      default:
        break
      }
    }
    
    performBatchUpdates({
      self.insertSections(insertion)
      self.deleteSections(deletion)
      for obj in moving {
        self.moveSection(obj.previousIndex!,toSection: obj.currentIndex!)
      }
    }) { (finished) in
      completion?()
    }
  }
}

extension UITableView {
  func ni_applyBatchChangesForRows(array: [NIArrayDiff], inSection section: Int, withRowAnimation animation: UITableViewRowAnimation) {
    var insertion = [NSIndexPath]()
    var deletion = [NSIndexPath]()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .Some(.Delete):
        deletion.append(NSIndexPath(forRow: obj.previousIndex!, inSection: section))
      case .Some(.Insert):
        insertion.append(NSIndexPath(forRow: obj.currentIndex!, inSection: section))
      case .Some(.Move):
        moving.append(obj)
      default:
        break
      }
    }
    
    beginUpdates()
    deleteRowsAtIndexPaths(deletion, withRowAnimation: animation)
    insertRowsAtIndexPaths(insertion, withRowAnimation: animation)
    for obj in moving {
      self.moveRowAtIndexPath((NSIndexPath(forRow: obj.previousIndex!, inSection: section),
                               toIndexPath: NSIndexPath(forRow: obj.currentIndex!, inSection: section)))
    }
    endUpdates()
  }
  
  func ni_applyBatchChangesForSections(array: [NIArrayDiff], withRowAnimation animation: UITableViewRowAnimation) {
    let insertion = NSMutableIndexSet()
    let deletion = NSMutableIndexSet()
    var moving = [NIArrayDiff]()
    
    for obj in array {
      switch obj.type {
      case .Some(.Delete):
        deletion.addIndex(obj.previousIndex!)
      case .Some(.Insert):
        insertion.addIndex(obj.currentIndex!)
      case .Some(.Move):
        moving.append(obj)
      default:
        break
      }
    }
    
    beginUpdates()
    deleteSections(deletion, withRowAnimation: animation)
    insertSections(insertion, withRowAnimation: animation)
    for obj in moving {
       self.moveSection(obj.previousIndex!,toSection: obj.currentIndex!)
    }
    endUpdates()
  }
}