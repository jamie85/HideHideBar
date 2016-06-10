//
//  Controller.swift
//  HideHideBar
//
//  Created by Jamie Sambi on 10/06/2016.
//  Copyright © 2016 Jamie Sambi. All rights reserved.
//

import Cocoa

class Controller: NSObject {

    @IBOutlet weak var menuBar: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    var showHiddenFiles: Bool = false
    
    override func awakeFromNib() {
        let icon = NSImage(named: "hideIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = menuBar
    }
    
    @IBAction func toggleClicked(sender: AnyObject) {
        toggleShowOrHide()
    }
    
    func toggleShowOrHide() {
        let hideIcon = NSImage(named: "hideIcon")
        let showIcon = NSImage(named: "showIcon")
        if showHiddenFiles == true {
            //turning it off - hiding files
            hideIcon?.template = true
            statusItem.image = hideIcon
            //statusItem.title = "Hide"
            showHiddenFiles = false
            shellHideHiddenfiles()
        } else {
            //turning it on - showing files
            showIcon?.template = true
            statusItem.image = showIcon
            //statusItem.title = "Show"
            showHiddenFiles = true
            shellShowHiddenFiles()
        }
    }
    
    func shellShowHiddenFiles() {
        shell("defaults", "write", "com.apple.finder", "AppleShowAllFiles", "YES")
        shell("pkill", "Finder")
    }
    
    func shellHideHiddenfiles() {
        shell("defaults", "write", "com.apple.finder", "AppleShowAllFiles", "NO")
        shell("pkill", "Finder")
    }
    
    func shell(args: String...) -> Int32 {
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
