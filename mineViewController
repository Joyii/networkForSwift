//
//  mineTalkListViewController.swift
//  My Heart
//
//  Created by Joyii on 2017/3/3.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit

class mineTalkListViewController: UITableViewController {

    var data = [Dictionary<String,Any>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let net = network()
        net.initRequst(HttpType: .get, content: "getUserTalks", dic: ["id":4])
        net.bindHandler { (dic) in
            self.data = dic
            self.tableView.reloadData()
            print(self.data)
        }
        net.sendRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTalksCell", for: indexPath)
        let text = cell.viewWithTag(10) as! UILabel
        let goods = cell.viewWithTag(11) as! UILabel
        let comments = cell.viewWithTag(12) as! UILabel
        text.text = data[indexPath.row]["content"] as? String
        goods.text = "收到的赞: \(data[indexPath.row]["goodNum"] as! Int)"
        comments.text = "收到的评论: \(data[indexPath.row]["commentNum"] as! Int)"
        return cell
    }
}
