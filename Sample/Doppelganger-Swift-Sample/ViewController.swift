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
  fileprivate var dataSource = [RowObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    generateDataSource()
  }

  fileprivate func generateDataSource() {
    
    let newDataSource = RowObject.listOfRowObjects() 
    let diffs = NIArrayDiffUtility.diffForCurrentArray(newDataSource, previousArray: dataSource)
    dataSource = newDataSource
    
    tableView.ni_applyBatchChangesForRows(diffs!, inSection: 0, withRowAnimation: .right)
    
    let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.generateDataSource()
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let rowObject = dataSource[(indexPath as NSIndexPath).row]
    cell.contentView.backgroundColor = rowObject.color
    cell.textLabel?.text = rowObject.title
    return cell
  }

}

