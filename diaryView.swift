//
//  diaryView.swift
//  My Heart
//
//  Created by Joyii on 2017/2/5.
//  Copyright © 2017年 Joyii. All rights reserved.
//


import UIKit

class diaryViewController: UIViewController {
    //UI View be made
    lazy var textF:UITextField = {
        let size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height/16)
        let y = (self.navigationController?.navigationBar.frame.maxY)! + 2
        let point = CGPoint(x: 0, y: y)
        let rect = CGRect(origin: point, size: size)
        let textf = UITextField(frame: rect)
        textf.backgroundColor = UIColor.white
        textf.textColor = UIColor.lightGray
        textf.clearsOnBeginEditing = true
        textf.text = "请输入密码..."
        return textf
    }()
    
    lazy var backgroundImage:UIImageView = {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        let background = UIImageView(frame: rect)
        return background
    }()
    
    lazy var sureButton:UIButton = {
        let origin = CGPoint(x: self.view.bounds.maxX/4 - 20, y: self.textF.frame.maxY + 20)
        let size = CGSize(width: 40, height: 20)
        let rect = CGRect(origin: origin, size: size)
        let bt = UIButton(frame: rect)
        bt.setTitle("确认", for: .normal)
        bt.setTitleColor(UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5), for: .normal)
        bt.setTitleColor(UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1), for: .highlighted)
        return bt
    }()
    
    lazy var exchagingButton:UIButton = {
        let origin = CGPoint(x: self.view.bounds.maxX*3/4 - 40, y: self.textF.frame.maxY + 20)
        let size = CGSize(width: 80, height: 20)
        let rect = CGRect(origin: origin, size: size)
        let bt = UIButton(frame: rect)
        bt.setTitle("修改密码", for: .normal)
        bt.setTitleColor(UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5), for: .normal)
        bt.setTitleColor(UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.1), for: .highlighted)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var exLoginInspect:Bool = false
    var pass:String?
    
    override func viewDidAppear(_ animated: Bool) {
        let coreD = coreDatas()
        let YN = coreD.checkTheInformation()
        if YN{
            //add different subview by coding
            //textF.borderStyle = .roundedRect
            backgroundImage.image = UIImage(named: "diaryLock")
            textF.delegate = self
            sureButton.addTarget(self, action: #selector(self.biubiu(sender:)), for: .touchUpInside)
            exchagingButton.addTarget(self, action: #selector(self.siusiu(sender:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(backgroundImage)
            self.view.addSubview(textF)
            self.view.addSubview(sureButton)
            self.view.addSubview(exchagingButton)
        }
        else{
            backgroundImage.image = UIImage(named: "errorDiaryView")
            self.view.addSubview(backgroundImage)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //custom button events
    func biubiu(sender: UIButton){
        let coreD = coreDatas()
        let results = coreD.extractInformation(enetiy: "Pass")
        if (results.first != nil){
            exLoginInspect = true
            pass = results.first?.value(forKey: "password") as? String
        }
        if exLoginInspect{
            if pass == self.textF.text {
                let vc = storyboard?.instantiateViewController(withIdentifier: "diaryListView") as! diaryListViewController
                    //获取用户日记数据from server
                    let net = network()
                    net.initRequst(HttpType: .get, content: "getUserDiarys", dic: ["id":staticClass.singel.userId!])
                    net.bindHandler { (dic) in
                        //解析日记数据
                        for i in dic{
                            let diary = diarys(mood: i["mood"] as! String, content: i["content"] as! String, date: i["date"] as! String, weather: i["weather"] as! String)
                            vc.diarys.append(diary)
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    net.sendRequest()
            }
            else{
                let alert = UIAlertController(title: "错误", message: "密码不正确", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "欢迎", message: "请点击修改密码设置新密码", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func siusiu(sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "exPasswordView") as! exPasswordViewController
        vc.notFirstLogin = self.exLoginInspect
        vc.sendClo { (str:Bool) in
            self.exLoginInspect = str
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension diaryViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        textField.returnKeyType = UIReturnKeyType.go
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
