//
//  loginView.swift
//  My Heart
//
//  Created by Joyii on 2017/2/4.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit
import CoreData

class loginIndexViewController: UIViewController{
    //登录逻辑全部由登录来处理
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var usernameTextF: UITextField!
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        //发送请求至服务器 如果返回user数据 若userid为-1则说明用户不存在
        let net = network()
        net.initRequst(HttpType: .post, content: "userLogin", dic: ["username":usernameTextF.text!,"password":passwordTextF.text!])
        net.bindHandler { (dic) in
            let userId = dic[0]["userId"] as! Int
            print(userId)
            if userId != -1{
                self.dismiss(animated: true, completion: { _ in
                    //save in CoreData
                    let coreD = coreDatas()
                    if coreD.saveData(entity: "Account", info: ["username":self.usernameTextF.text!,"password":self.passwordTextF.text!,"userid":userId]){
                    }
                    //通过protocol的形式 发送消息给主界面
                    self.delegate?.sendMessage!(str: self.usernameTextF.text!)
                })
            }
        }
        net.sendRequest()

    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    var delegate:sending?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextF.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signup"{
            let vc = segue.destination as! signUpViewController
            vc.sendClouser(clouser: { [unowned self](user, pass) in
                self.usernameTextF.text = user
                self.passwordTextF.text = pass
            })
        }
    }

}

extension loginIndexViewController: UITextFieldDelegate{
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
