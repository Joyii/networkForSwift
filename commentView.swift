//
//  commentView.swift
//  My Heart
//
//  Created by Joyii on 2017/3/2.
//  Copyright © 2017年 Joyii. All rights reserved.
//

import UIKit

class commentViewController: UIViewController {
    
    var talkData:Talks?
    @IBOutlet weak var textView: UITextView!
    var first = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commit(_ sender: UIButton) {
        //提交至server
        let net = network()
        net.initRequst(HttpType: .post, content: "comments", dic: ["commentContent":self.textView.text,"talkId":talkData!.talkId,"commentDate":talkData!.date])
        net.bindHandler { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        net.sendRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension commentViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView){
        textView.textColor = UIColor.black
        if first{
            textView.text = ""
            first = false
        }
    }
}
