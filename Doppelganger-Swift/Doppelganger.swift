//
//  Doppelganger.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 20/06/2018.
//  Copyright © 2018 Szymon Maślanka. All rights reserved.
//

import Foundation
import UIKit

final class Doppelganger {
    enum Difference {
        case move(from: Int, to: Int)
        case insert(new: Int)
        case delete(old: Int)
        
        var description: String {
            switch self {
            case .move(let from, let to):
                return "\(String(describing: self)) {type=move; from=\(from); to=\(to)}"
            case .insert(let new):
                return "\(String(describing: self)) {type=insertion; new=\(new)}"
            case .delete(let old):
                return "\(String(describing: self)) {type=delete; old=\(old)}"
            }
        }
    }
    
    class func difference<T: Hashable>(currentArray: [T], previousArray: [T]) -> [Difference] {
        
        let previousSet = Set(previousArray)
        let currentSet = Set(currentArray)
        print("previousSet : \(previousSet)")
        print("currentSet : \(currentSet)")
        
        let deletedObjects = previousSet.subtracting(currentSet)
        let insertedObjects = currentSet.subtracting(previousSet)
        print("deletedObjects : \(deletedObjects)")
        print("insertedObjects : \(insertedObjects)")
        
        
        let deletionDiffs = deletions(array: previousArray, deletedObjects: deletedObjects)
        let insertionDiffs = insertions(array: currentArray, insertedObjects: insertedObjects)
        let moveDiffs = moves(currentArray: currentArray, previousArray: previousArray, deletedObjects: deletedObjects, insertedObjects: insertedObjects)
        
        return deletionDiffs + insertionDiffs + moveDiffs
    }

    private class func deletions<T: Hashable>(array: [T], deletedObjects: Set<T>) -> [Difference] {
        var result = [Difference]()
        for (index, obj) in array.enumerated() {
            if !deletedObjects.contains(obj) {
                continue
            }
            result.append(.delete(old: index))
        }
        return result
    }
    
    private class func insertions<T: Hashable>(array: [T], insertedObjects: Set<T>) -> [Difference] {
        var result = [Difference]()
        for (index, obj) in array.enumerated() {
            if !insertedObjects.contains(obj) {
                continue
            }
            result.append(.insert(new: index))
        }
        return result
    }
    
    private class func moves<T: Hashable>(currentArray: [T], previousArray: [T], deletedObjects: Set<T>, insertedObjects: Set<T>) -> [Difference] {
        var delta = 0
        var result = [Difference]()
        
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
                    result.append(.move(from: indexPrevious, to: indexCurrent))
                }
                break
            }
        }
        
        return result
    }
    
    typealias RowSplitResult = (insertion: [IndexPath], deletion: [IndexPath], move: [(IndexPath, IndexPath)])
    fileprivate class func splitRows(array: [Difference], in section: Int) -> RowSplitResult {
        var insertion = [IndexPath]()
        var deletion = [IndexPath]()
        var move = [(IndexPath, IndexPath)]()
        
        for type in array {
            switch type {
            case .delete(let old):
                deletion.append(IndexPath(row: old, section: section))
            case .insert(let new):
                insertion.append(IndexPath(row: new, section: section))
            case .move(let from, let to):
                move.append((IndexPath(row: from, section: section), IndexPath(row: to, section: section)))
            }
        }
        
        return (insertion, deletion, move)
    }
    
    typealias SectionSplitResult = (insertion: IndexSet, deletion: IndexSet, move: [(Int, Int)])
    fileprivate class func splitSections(array: [Difference]) -> SectionSplitResult {
        let insertion = NSMutableIndexSet()
        let deletion = NSMutableIndexSet()
        var move = [(Int, Int)]()
        
        for type in array {
            switch type {
            case .delete(let old):
                deletion.add(old)
            case .insert(let new):
                insertion.add(new)
            case .move(let from, let to):
                move.append((from, to))
            }
        }
        
        return (insertion as IndexSet, deletion as IndexSet, move)
    }
}

extension UICollectionView {
    func performItemUpdates(array: [Doppelganger.Difference], inSection section: Int) {
        let result = Doppelganger.splitRows(array: array, in: section)
        
        performBatchUpdates({
            self.insertItems(at: result.insertion)
            self.deleteItems(at: result.deletion)
            result.move.forEach { self.moveItem(at: $0.0, to: $0.1) }
        }) { (finished) in }
    }
    
    func performSectionUpdates(array: [Doppelganger.Difference]) {
        let result = Doppelganger.splitSections(array: array)
        
        performBatchUpdates({
            self.insertSections(result.insertion)
            self.deleteSections(result.deletion)
            result.move.forEach { self.moveSection($0.0, toSection: $0.1) }
        }) { (finished) in }
    }
}

extension UITableView {
    func performRowUpdates(array: [Doppelganger.Difference], inSection section: Int, withRowAnimation animation: UITableView.RowAnimation) {
        let result = Doppelganger.splitRows(array: array, in: section)
        
        beginUpdates()
        deleteRows(at: result.deletion, with: animation)
        insertRows(at: result.insertion, with: animation)
        result.move.forEach { moveRow(at: $0.0, to: $0.1) }
        endUpdates()
    }
    
    func performSectionUpdates(array: [Doppelganger.Difference], withRowAnimation animation: UITableView.RowAnimation) {
        let result = Doppelganger.splitSections(array: array)
        
        beginUpdates()
        deleteSections(result.deletion, with: animation)
        insertSections(result.insertion, with: animation)
        result.move.forEach { moveSection($0.0, toSection: $0.1) }
        endUpdates()
    }
}
