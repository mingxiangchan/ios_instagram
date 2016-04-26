//
//  SearchViewController.swift
//  ios_instagram
//
//  Created by Abdo Assem on 4/26/16.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var usersArray = [User]()
    var filteredUsers = [User]()
    let searchController = UISearchController(searchResultsController: nil)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataServices.dataService.USER_REF.observeEventType(.ChildAdded, withBlock: { (snapshot)-> Void in
            if let value = snapshot.value as? [String : AnyObject]{
                let user = User(key:snapshot.key, dict:value)
                self.usersArray.append(user)
                self.tableView.reloadData()
                
                //  self.searchBar.showsCancelButton=true
                //self.searchBar.showsScopeBar=true
              
            
            }
            })
    
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation=false
        definesPresentationContext=true
        tableView.tableHeaderView=searchController.searchBar
    }
    

    func filterContentforSearch(searchtext:String, scope:String="All") {
        filteredUsers=usersArray.filter{
            user in
            return user.username.lowercaseString.containsString(searchtext.lowercaseString)
        }
        self.tableView.reloadData()
    }
    
    
    
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
        if (searchController.active == true && searchController.searchBar.text != "") {
            return self.filteredUsers.count
        }
        
        
        return usersArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let uuser:User
        if (searchController.active == true && searchController.searchBar.text != "") {
            uuser = filteredUsers[indexPath.row]

        }else{
        uuser = usersArray[indexPath.row]
        }
        cell?.textLabel?.text = uuser.username
        cell?.detailTextLabel?.text = uuser.email
        return cell!
        
    }

}
extension SearchViewController:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentforSearch(searchController.searchBar.text!)
    }}


