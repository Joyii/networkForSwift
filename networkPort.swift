import Foundation
typealias afterCompletionHandler = (_ dic:[Dictionary<String,Any>]) -> Void


class network{
    private var req:NSMutableURLRequest?
    var handler:afterCompletionHandler?
    
    //初始化网络请求
    func initRequst(HttpType: httpType,content:String,dic:Dictionary<String,Any>){
        let url:URL?
        let data = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        switch HttpType {
        case .post:
            url = URL.init(string: "http://localhost:5000/" + content)
            req = NSMutableURLRequest.init(url: url!)
            req!.httpMethod = "POST"
            req!.httpBody = data
            req!.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req!.setValue("application/json", forHTTPHeaderField: "Accept")
        case .get:
            url = URL(string: "http://localhost:5000/" + content + "/\(dic["id"]!)")
            req = NSMutableURLRequest.init(url: url!)
            req!.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req!.setValue("application/json", forHTTPHeaderField: "Accept")
        }
    }
    
    func bindHandler(clo:@escaping afterCompletionHandler){
        handler = clo
    }
    //发送网络请求并接收数据  研究错误处理
    func sendRequest(){
        let session = URLSession.shared
        //自然异步 利用逃逸闭包等待接收的respones从而不再阻塞主线程
        let dataTask:URLSessionDataTask = session.dataTask(with: req! as URLRequest, completionHandler: {
            (data, respons, error) in
            if error == nil {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [Dictionary<String,Any>]
                    print(json)
                    //sending Closure 做异步处理
                    self.handler!(json)
                }
                catch{
                    print("错误传输")
                }
             
            }
            else{
                print("Networl Error:!!!!!!!!!!!!!!!!!!")
                print(error?.localizedDescription)
            }
        })
        dataTask.resume()
    }
    
}
