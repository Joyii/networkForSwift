import Foundation

struct accounts {
    var username:String
    var password:String
}
//2
struct diarys {
    var mood:String
    var content:String
    var date:String
    var weather:String
    init(mood:String,content:String,date:String,weather:String) {
        self.mood = mood
        self.content = content
        self.date = date
        self.weather = weather
    }
}
//1
struct Talks {
    var commentNum:Int
    var goodNum:Int
    var contents:String
    var location:String
    var talkId:Int
    var date:String
    init(commentNum:Int,goodNum:Int,content:String,location:String,talkId:Int,date:String) {
        self.contents = content
        self.commentNum = commentNum
        self.goodNum = goodNum
        self.location = location
        self.date = date
        self.talkId = talkId
    }
}

struct Comments {
    var content:String
    var date:String
    init(content:String,date:String) {
        self.content = content
        self.date = date
    }
}

enum httpType:String{
    case post
    case get
}
