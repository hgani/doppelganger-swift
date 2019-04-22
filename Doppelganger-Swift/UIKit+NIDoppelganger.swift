//
//  UIKit+NIDoppelganger.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import UIKit

extension UICollectionView {
	public func ni_applyBatchChangesForRows(_ array: [NIArrayDiffType], inSection section: Int, completion: (()->())? = nil) {
		var insertion = [IndexPath]()
		var deletion = [IndexPath]()
		var moving = [(IndexPath,IndexPath)]()
		
		for type in array {
			switch type {
			case .delete(let old):
				deletion.append(IndexPath(row: old, section: section))
			case .insert(let new):
				insertion.append(IndexPath(row: new, section: section))
			case .move(let from, let to):
				moving.append((IndexPath(row: from, section: section), IndexPath(row: to, section: section)))
			}
		}
		
		performBatchUpdates({
			self.insertItems(at: insertion)
			self.deleteItems(at: deletion)
			moving.forEach { self.moveItem(at: $0.0, to: $0.1) }
		}) { (finished) in
			completion?()
		}
	}
	
	func ni_applyBatchChangesForSections(_ array: [NIArrayDiffType], completion: (()->())? = nil) {
		let insertion = NSMutableIndexSet()
		let deletion = NSMutableIndexSet()
		var moving = [(Int, Int)]()
		
		for type in array {
			switch type {
			case .delete(let old):
				deletion.add(old)
			case .insert(let new):
				insertion.add(new)
			case .move(let from, let to):
				moving.append((from, to))
			}
		}
		performBatchUpdates({
			self.insertSections(insertion as IndexSet)
			self.deleteSections(deletion as IndexSet)
			moving.forEach { self.moveSection($0.0, toSection: $0.1) }
		}) { (finished) in
			completion?()
		}
	}
}

extension UITableView {
    public func ni_applyBatchChangesForRows(_ array: [NIArrayDiffType], inSection section: Int, withRowAnimation animation: UITableView.RowAnimation) {
		
		var insertion = [IndexPath]()
		var deletion = [IndexPath]()
		var moving = [(IndexPath,IndexPath)]()
		
		for type in array {
			switch type {
			case .delete(let old):
				deletion.append(IndexPath(row: old, section: section))
			case .insert(let new):
				insertion.append(IndexPath(row: new, section: section))
			case .move(let from, let to):
				moving.append((IndexPath(row: from, section: section), IndexPath(row: to, section: section)))
			}
		}
		
		beginUpdates()
		deleteRows(at: deletion, with: animation)
		insertRows(at: insertion, with: animation)
		moving.forEach { moveRow(at: $0.0, to: $0.1) }
		endUpdates()
	}
	
    func ni_applyBatchChangesForSections(_ array: [NIArrayDiffType], withRowAnimation animation: UITableView.RowAnimation) {
		let insertion = NSMutableIndexSet()
		let deletion = NSMutableIndexSet()
		var moving = [(Int, Int)]()
		
		for type in array {
			switch type {
			case .delete(let old):
				deletion.add(old)
			case .insert(let new):
				insertion.add(new)
			case .move(let from, let to):
				moving.append((from, to))
			}
		}
		
		beginUpdates()
		deleteSections(deletion as IndexSet, with: animation)
		insertSections(insertion as IndexSet, with: animation)
		moving.forEach { moveSection($0.0, toSection: $0.1) }
		endUpdates()
	}
}
