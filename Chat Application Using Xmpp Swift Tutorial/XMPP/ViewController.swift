//
//  ViewController.swift
//  XMPP
//
//  Created by Priyank on 23/08/16.
//  Copyright © 2016 Shubhank. All rights reserved.
//

import UIKit
import XMPPFramework

class ViewController: UIViewController, XMPPStreamDelegate {

    var stream:XMPPStream!
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)

        stream = XMPPStream()
        stream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppRoster.activate(stream)
        

        stream.myJID = XMPPJID.jidWithString("user1@localhost")
        
        do {
            try stream.connectWithTimeout(30)
        }
        catch {
            print("catch")
            
        }
        
        
        let button = UIButton()
        button.backgroundColor = UIColor.redColor()
        button.setTitle("SendMessage", forState: .Normal)
        button.frame = CGRectMake(90, 100, 300, 40)
        button.addTarget(self, action: #selector(self.sendMessage), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button)
    }
    
    func sendMessage() {

        let message = "Yo!"
        let senderJID = XMPPJID.jidWithString("user2@localhost")
        let msg = XMPPMessage(type: "chat", to: senderJID)
        
        msg.addBody(message)
        stream.sendElement(msg)
    }
    
    
    func xmppStreamWillConnect(sender: XMPPStream!) {
        print("will connect")
    }
    
    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
        print("timeout:")
    }
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        print("connected")
        
        do {
            try sender.authenticateWithPassword("123")
        }
        catch {
            print("catch")
            
        }

    }
    
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("auth done")
        sender.sendElement(XMPPPresence())
    }
    

    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print("dint not auth")
        print(error)
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        print(presence)
        let presenceType = presence.type()
        let username = sender.myJID.user
        let presenceFromUser = presence.from().user
        
        if presenceFromUser != username  {
            if presenceType == "available" {
                print("available")
            }
            else if presenceType == "subscribe" {
                self.xmppRoster.subscribePresenceToUser(presence.from())
            }
            else {
                print("presence type"); print(presenceType)
            }
        }
   
    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        print("sent")
    }
    
    func xmppStream(sender: XMPPStream!, didFailToSendIQ iq: XMPPIQ!, error: NSError!) {
        print("error")
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveError error: DDXMLElement!) {
        print("error")
    }
    
    func xmppStream(sender: XMPPStream!, didFailToSendMessage message: XMPPMessage!, error: NSError!) {
        print("fail")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print(message)
    }
}

