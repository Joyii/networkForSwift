//
//  topicView.swift
//  My Heart
//
//  Created by Joyii on 2017/2/5.
//  Copyright © 2017年 Joyii. All rights reserved.
//


import UIKit
import CoreLocation

class topicViewController: UIViewController,sending{
    //lazy init showing view
    lazy var changingView:UIView = {
        let province = ["Zhejiang","Jiangsu","Fujian","Beijing","Hunan","Hubei","Guangdong","Liaoning","Shanghai"]
        let view = UIView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 5, width: self.view.frame.width, height: self.view.frame.height/3))
        view.backgroundColor = UIColor.white
        for i in 0...8{
            let button = UIButton()
            button.frame = CGRect(x: CGFloat(Int(i%3))*100 + 40, y: view.frame.minY + 10 + 75*CGFloat(Int(i/3)), width: 80, height: 40)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitle(province[i], for: .normal)
            button.addTarget(self, action: #selector(self.changeLocation(sender:)), for: .touchUpInside)
            view.addSubview(button)
        }
        return view
    }()
    
    func changeLocation(sender:UIButton){
        address = sender.titleLabel?.text
        changingView.isHidden = true
        self.navigationItem.rightBarButtonItem?.title = address
    }
    
    @IBOutlet weak var tableView: UITableView!
    //用于接收服务器的用户名
    private var username:String?
    var address:String?{
        didSet{
            if let a = address{
                reloadData(location: a)
            }
        }
    }
    var talks:[Talks] = []
    var first:Bool = true
    let locationManager = CLLocationManager()
    
    @IBAction func relocate(_ sender: UIBarButtonItem) {
        if first{
            self.view.addSubview(changingView)
            first = false
        }
        else{
            changingView.isHidden = false
        }
    }
    
    @IBAction func login(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "loginIndexView") as! loginIndexViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
        //定位模块初始化
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        //自行检测登录
        let coreD = coreDatas()
        let YN = coreD.checkTheInformation()
        if YN{
            self.username = coreD.username  //for viewing name
            navigationButtonAndStartLocate()
        }
        else{
            let alert = UIAlertController(title: "定位失败", message: "请您先登录", preferredStyle: .alert)
            let action = UIAlertAction(title: "确认", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //login callback start
    func sendMessage(str: String) {
        self.username = str
        navigationButtonAndStartLocate()
    }
    
    func navigationButtonAndStartLocate(){
        self.navigationItem.leftBarButtonItem?.title = self.username
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        //locate user location
        // tips once the setting is on its not work automatically
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let a = address{
            reloadData(location: a)
        }
    }
    //以location为输入值
    func reloadData(location:String){
        let net = network()
        net.initRequst(HttpType: .get, content: "getTalkFromLocation", dic: ["id":location])
        net.bindHandler { [unowned self](dic) in
            self.talks = []
            for i in dic{
                let talk = Talks.init(commentNum: i["commentNum"] as! Int, goodNum: i["goodNum"] as! Int, content: i["content"] as! String, location: " ", talkId: i["talkId"] as! Int, date: i["date"] as! String)
                self.talks.append(talk)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        net.sendRequest()
    }
}

extension topicViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location!, completionHandler: { (dic,error) in
            if let address = dic?[0].administrativeArea{
                self.navigationItem.rightBarButtonItem?.title = address
                self.address = address
                manager.stopUpdatingLocation()
            }
//            if let a = self.address{
//                self.reloadData(location: a)
//            }
        })
    }
}

extension topicViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return talks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationTalksCell", for: indexPath)
        let text = cell.viewWithTag(10) as! UITextView
        let goods = cell.viewWithTag(11) as! UILabel
        let comments = cell.viewWithTag(12) as! UILabel
        text.text = talks[indexPath.row].contents
        goods.text = "\(talks[indexPath.row].goodNum)"
        comments.text = "\(talks[indexPath.row].commentNum)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = storyboard?.instantiateViewController(withIdentifier: "talkDetailView") as! talkDetailViewController
        vc.talkData = talks[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}
