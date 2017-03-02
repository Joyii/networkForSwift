import UIKit
import CoreData

class coreDatas {
    let ctx = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //用户名
    var username:String?

    func checkTheInformation() -> Bool {
            let results =  extractInformation(enetiy: "Account")
            let userInfo = results.first
            let username = userInfo?.value(forKey: "username") as? String
            if username != nil {
                staticClass.singel.userId = userInfo?.value(forKey: "userid") as? Int
                self.username = username
                return true
            }
            return false
    }
    
    func saveData(entity name:String,info dic:Dictionary<String, Any>) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: name, in: ctx)
        let info = NSManagedObject(entity: entity!, insertInto: ctx)
        info.setValuesForKeys(dic)
        do{
            try ctx.save()
            return true
        }
        catch{
            return false
        }
    }

    func extractInformation(enetiy name:String) -> [NSManagedObject]{
        let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: name)
        let results = try! ctx.fetch(req) as! [NSManagedObject]
        return results
    }
    
}
