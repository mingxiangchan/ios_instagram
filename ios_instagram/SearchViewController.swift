//
//  SearchViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/26/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
var usersArray = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataServices.dataService.USER_REF.observeEventType(.ChildAdded, withBlock: { (snapshot)-> Void in
            if let value = snapshot.value as? [String : AnyObject]{
                let user = User(key:snapshot.key, dict:value)
                self.usersArray.append(user)
                self.tableView.reloadData()
                  self.searchBar.delegate=self
                self.searchBar.showsCancelButton=true
                self.searchBar.showsScopeBar=true
              
            
            }
            })
    
      
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let indexpath=tableView.indexPathForSelectedRow!
//        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
//        let _valueToPass = currentCell.textLabel!.text
//        performSegueWithIdentifier("toDetailViewController", sender: self)
//        
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
//        
//        if (segue.identifier == "toDetailViewController") {
//            
//            var viewController = segue.destinationViewController as! SearchDetailViewController
//            // your new view controller should have property that will store passed value
//            viewController.passedValue = valueToPass
//        }
//        
//    }

    
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "toDetailViewController" {
            if let destination = segue.destinationViewController as? SearchDetailViewController {
                if let iindex = tableView.indexPathForSelectedRow?.row {
                    destination.userProfile = usersArray[iindex]
              }
          }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let uuser = usersArray[indexPath.row]
        cell?.textLabel?.text = uuser.email
        cell?.detailTextLabel?.text = uuser.username
        return cell!
        
    }
 
    @IBAction func onSearchbarTapped(sender: UITapGestureRecognizer) {
        print("searchBar tapped")
    }


}


