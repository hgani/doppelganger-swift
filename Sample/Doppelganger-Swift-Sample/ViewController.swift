//
//  ViewController.swift
//  Doppelganger-Swift-Sample
//
//  Created by Szymon Maślanka on 17/03/16.
//  Copyright © 2016 Szymon Maślanka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  private var dataSource = [RowObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    generateDataSource()
  }

  private func generateDataSource() {
    
    let newDataSource = RowObject.listOfRowObjects() as! [RowObject]
    let diffs = NIArrayDiffUtility.diffForCurrentArray(newDataSource, previousArray: dataSource)
    dataSource = newDataSource
    
    tableView.ni_applyBatchChangesForRows(diffs!, inSection: 0, withRowAnimation: .Right)
    
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.generateDataSource()
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    let rowObject = dataSource[indexPath.row]
    cell.contentView.backgroundColor = rowObject.color
    cell.textLabel?.text = rowObject.title
    return cell
  }

}

