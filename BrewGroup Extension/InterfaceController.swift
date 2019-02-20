 

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    var imagestatusvalue = ""
    @IBOutlet weak var playorpause: WKInterfaceButton!
    @IBOutlet weak var PayAndPause: WKInterfaceButton!
    var wcsession = WCSession.default
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session complete")
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
    }
    
    @objc func didrecive(notificaiont: Notification) {
        print(notificaiont.object ?? "") //myObject
        print(notificaiont.userInfo ?? "") //[AnyHashable("key"): "Value"]
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        wcsession = WCSession.default
        wcsession.delegate = self
        wcsession.activate()
        imagestatusvalue =  "pause"
        PayAndPause.setBackgroundImageNamed("pause")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print(userInfo)
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        var messageStatus = message["playerStatus"] as! String
        
        if messageStatus == "pauseaction"{
            PayAndPause.setBackgroundImageNamed("playIcon1")
            imagestatusvalue = "playaction"
        }
        if messageStatus == "playaction"{
            PayAndPause.setBackgroundImageNamed("pause")
            imagestatusvalue = "pause"
        }
        
        print(message)
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func playaction() {
        print("playaction")
        
        print(PayAndPause)
        var selectstatus = true
        if imagestatusvalue ==  "pause" && selectstatus == true {
            selectstatus = false
            imagestatusvalue = "playaction"
            PayAndPause.setBackgroundImageNamed("pause")
            let stringsend = ["action" : "play"]
            self.wcsession.sendMessage(stringsend, replyHandler: nil, errorHandler:{ error in
                print(error.localizedDescription)
            })
            
        }
        if imagestatusvalue ==  "playaction" && selectstatus == true{
            imagestatusvalue = "pause"
            selectstatus = false
            
            PayAndPause.setBackgroundImageNamed("playIcon1")
            let stringsend = ["action" : "pause"]
            self.wcsession.sendMessage(stringsend, replyHandler: nil, errorHandler:{ error in
                print(error.localizedDescription)
            })
            
        }
        
        
        
        var stringtest = PayAndPause.description
        
        print(stringtest)
        // PayAndPause.setBackgroundImageNamed("pause")
    }
    
    
    @IBAction func backseek30second() {
        let stringsend = ["action" : "seekbackward30second"]
        self.wcsession.sendMessage(stringsend, replyHandler: nil, errorHandler:{ error in
            print(error.localizedDescription)
        })
        
    }
    
    @IBAction func forwardSeek30Second() {
        let stringsend = ["action" : "seekforwordward30second"]
        self.wcsession.sendMessage(stringsend, replyHandler: nil, errorHandler:{ error in
            print(error.localizedDescription)
        })
    }
 }

