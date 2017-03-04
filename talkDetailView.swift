//
//  talkDetailView.swift
//  My Heart
//
//  Created by Joyii on 2017/3/1.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit

class talkDetailViewController: UIViewController{

    var talkData:Talks?
    var comments = [Comments]()
    let net = network()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBAction func goodTapped(_ sender: UIButton) {
        net.initRequst(HttpType: .post, content: "postGood", dic: ["talkId":talkData!.talkId])
        net.bindHandler { (_) in
            sender.titleLabel?.text = "谢谢"
            sender.isEnabled = false
        }
        net.sendRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
        tableView.delegate = self
        tableView.dataSource = self
        net.initRequst(HttpType: .get, content: "getTalkComments", dic: ["id":talkData!.talkId])
        net.bindHandler { (dic) in
            for i in dic{
                let newDate = self.handleString(date: i["date"] as! String)
                let comment:Comments = Comments.init(content: i["content"] as! String, date: newDate)
                self.comments.append(comment)
            }
            self.tableView.reloadData()
        }
        net.sendRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleString(date:String) -> String{
        let format = DateFormatter()
        //截断字符串 匹配date型
        let subDate = date.substring(with: Range.init(uncheckedBounds: (lower: (date.characters.index(of: " "))!, upper: (date.characters.index(of: "G"))!)))
        format.dateFormat = "dd MM yyyy HH:mm:ss"
        let newDate = format.date(from: subDate)
        //自由定义date型 格式
        format.dateFormat = "yyyy.MM.dd HH:mm"
        let str = format.string(from: newDate!)
        return "write in  " + str

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! commentViewController
        vc.talkData = talkData
    }
    
}
