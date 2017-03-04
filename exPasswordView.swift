//
//  exPasswordView.swift
//  My Heart
//
//  Created by Joyii on 2017/2/20.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit
typealias clousur = (_ str:Bool) -> Void

class exPasswordViewController: UIViewController {
    
    @IBOutlet weak var pasTextF: UITextField!
    @IBOutlet weak var passTextF: UITextField!
    
    var clouser:clousur?
    var notFirstLogin:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(self.navItem(sender:)))
        self.pasTextF.delegate = self
        self.passTextF.delegate = self
        if notFirstLogin == false{
            self.pasTextF.text = "第一次设置请忽略此栏"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navItem(sender:UIBarButtonItem){
        let coreD = coreDatas()
        if notFirstLogin!{
            let results = coreD.extractInformation(enetiy: "Pass")
            if self.pasTextF.text == results.first?.value(forKey: "password") as? String{
                results.first?.setValue(self.passTextF.text, forKey: "password" )
                self.navigationController?.popViewController(animated: true)
            }
            else{
                let alert = UIAlertController(title: "密码修改失败", message: "旧密码错误", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "不可以看他人日记", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        else{
            coreD.saveData(entity: "Pass", info: ["password":self.passTextF.text!])
            //反向传值 修改insepect password
            clouser!(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    func sendClo(clo:@escaping clousur){
        self.clouser = clo
    }
    
}
                    
extension exPasswordViewController: UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.textColor = UIColor.black
        
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
