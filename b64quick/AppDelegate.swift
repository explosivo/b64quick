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
        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = MenuView()
        popover.delegate = self
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.target = self
        }
        
        if let menu = menu {
            menu.delegate = self
        }
    }
    
    func togglePopover(_ sender: NSButton) {
        if NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option) {
            self.statusBarItem.menu = self.menu
            self.statusBarItem.button?.performClick(nil)
        }
        else {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
                sender.bounds = sender.bounds.offsetBy(dx: 0, dy: sender.bounds.height)
                if let popoverWindow = popover.contentViewController?.view.window {
                    popoverWindow.setFrame(popoverWindow.frame.offsetBy(dx: 0, dy: 13), display: false)
                }
            }
            
        }
    }
}

extension NSStatusBarButton {
    public override func mouseDown(with event: NSEvent) {
        (self.target as? AppDelegate)?.togglePopover(self)
    }
}

extension AppDelegate : NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        self.statusBarItem.button?.highlight(false)
    }
    
    func popoverDidShow(_ notification: Notification) {
        self.statusBarItem.button?.highlight(true)
    }
}

extension AppDelegate : NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        statusBarItem?.menu = nil
    }
}
