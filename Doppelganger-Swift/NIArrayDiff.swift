//
//  NIArrayDiff.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import Foundation

public enum NIArrayDiffType {
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
