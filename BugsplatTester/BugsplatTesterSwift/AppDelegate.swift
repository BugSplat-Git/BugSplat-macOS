//
//  AppDelegate.swift
//  BugsplatTesterSwift
//
//  Created by Geoff Raeder on 5/27/18.
//  Copyright © 2018 Bugsplat. All rights reserved.
//

import Cocoa
import BugsplatMac

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, BugsplatStartupManagerDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        BugsplatStartupManager.shared().delegate = self
        BugsplatStartupManager.shared().start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func performCrash() {
        let closure: (() -> Void)? = nil
        closure!()
    }

    @IBAction func crash(_ sender: Any) {
        self.performCrash()
    }
    
    // MARK: BugsplatStartupManagerDelegate
}

