//
//  AppDelegate.swift
//  b64quick
//
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    @IBOutlet weak var menu: NSMenu!
    var statusBarItem: NSStatusItem!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        if let menu = menu {
            menu.delegate = self
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option) {
            self.statusBarItem.menu = self.menu
            self.statusBarItem.button?.performClick(nil)
        }
        else {
             if let button = self.statusBarItem.button {
                  if self.popover.isShown {
                       self.popover.performClose(sender)
                  } else {
                       self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                  }
             }
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate : NSMenuDelegate {    
    func menuDidClose(_ menu: NSMenu) {
        statusBarItem?.menu = nil
    }
}

