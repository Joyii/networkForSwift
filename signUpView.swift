//
//  signUpView.swift
//  My Heart
//
//  Created by Joyii on 2017/2/4.
//  Copyright © 2017年 Joyii. All rights reserved.
//



import UIKit
typealias users = (_ username:String,_ password:String) -> Void

class signUpViewController: UIViewController {
    
    var userInfo:users?
    @IBOutlet weak var usernameTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sureButtonTapped(_ sender: UIButton) {
        //check the username and wait the server response
        //服务器端存储
        let net = network()
        net.initRequst(HttpType: .post, content: "usersInformation", dic: ["username":usernameTextF.text!,"password":passwordTextF.text!])
        net.bindHandler(clo: { [unowned self](_) in
            self.dismiss(animated: true, completion: { _ in
                self.userInfo!(self.usernameTextF.text!,self.passwordTextF.text!)
            })
        })
        net.sendRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextF.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //sending Closure
    func sendClouser(clouser:@escaping users){
        userInfo =  clouser
    }
    
}

extension signUpViewController: UITextFieldDelegate{
    public func textFieldDidBeginEditing(_ textField: UITextField){
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
        
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
