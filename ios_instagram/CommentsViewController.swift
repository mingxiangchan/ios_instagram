//
//  CommentsViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 26/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var picture: Picture?
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTitle("COMMENTS")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CommentCell")!
        return cell
    }

    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(0,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        lbNavTitle.text = string
        self.navigationItem.titleView = lbNavTitle;
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
}
