//
//  SearchViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/26/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
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
            }
            })
        
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
    
}
