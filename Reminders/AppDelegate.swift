//
//  AppDelegate.swift
//  Reminders
//
//  Created by Mike Odom on 5/14/15.
//  Copyright (c) 2015 Mike Odom. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        displayNewReminder()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(24*60*60, target: self, selector: Selector("displayNewReminder"), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func displayNewReminder() {
        if let db = getDatabase() {
            var array = NSMutableArray.new()
            
            if let rs = db.executeQuery("SELECT * FROM reminders", withArgumentsInArray: nil) {
                while rs.next() {
                    let text = rs.stringForColumn("text")
                    array.addObject(text)
                }
            }
            
            let t = Int(arc4random_uniform((UInt32)(array.count)))
            
            let reminderText: String = array.objectAtIndex(t) as! String
            
            var notification = NSUserNotification.new()
            
            println("Reminder text: " + reminderText)
            
            notification.title = "Hello, Odie!"
            notification.informativeText = reminderText
            notification.actionButtonTitle = "Got it!"
            notification.hasActionButton = true

//            notification.activationType = ActionButtonClicked;
//            notification.soundName = NSUserNotificationDefaultSoundName;
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
            
            db.close()
        }
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        
    }
    
    func getDatabase() -> FMDatabase? {
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let path = documentsFolder.stringByAppendingPathComponent("Reminders.sqlite")
        
        NSLog(path)
        
        let database = FMDatabase(path: path)
        
        if !database.open() {
            println("Unable to open database")
            return nil
        }
        
        return database
    }


    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        
        // If we got here, it is time to quit.
        return .TerminateNow
    }

}

