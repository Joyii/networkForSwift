//
//  diaryListViewController.swift
//  My Heart
//
//  Created by Joyii on 2017/2/21.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit

class diaryListViewController: UITableViewController {

    var diarys:[diarys] = []
    var networkOn:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        //消除footer分割线 加载view
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.newDiary))
        }
    
    //new diary view shows
    func newDiary(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "newDiaryView")
        present(vc!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCells", for: indexPath)
            cell.textLabel?.text = diarys[indexPath.row].mood
            let date = diarys[indexPath.row].date
            let format = DateFormatter()
            //截断字符串 匹配date型
            let subDate = date.substring(with: Range.init(uncheckedBounds: (lower: (date.characters.index(of: " "))!, upper: (date.characters.index(of: "G"))!)))
            format.dateFormat = "dd MM yyyy HH:mm:ss"
            let newDate = format.date(from: subDate)
            //自由定义date型 格式
            format.dateFormat = "yyyy.MM.dd HH:mm"
            let str = format.string(from: newDate!)
            cell.detailTextLabel?.text = "in  " + str
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //日记详情 界面正向传值
        let vc = storyboard?.instantiateViewController(withIdentifier: "diaryDetailView") as! diaryDetailViewController
        vc.diaryDataSource = diarys[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
