//
//  TrackOBotPreferences.swift
//  HSTracker
//
//  Created by Benjamin Michotte on 3/08/16.
//  Copyright © 2016 Benjamin Michotte. All rights reserved.
//

import Foundation
import MASPreferences
import AppKit

class TrackOBotPreferences: NSViewController {
    
    @IBOutlet weak var synchronizeMatches: NSButton!
    @IBOutlet weak var openProfile: NSButton!
    @IBOutlet weak var loginButton: NSButton!
    private var trackobotLogin: TrackOBotLogin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synchronizeMatches.state = Settings.trackobotSynchronizeMatches ? .on : .off

        reloadStates()
    }

    private func reloadStates() {
        synchronizeMatches.isEnabled = TrackOBotAPI.isLogged()
        openProfile.isEnabled = TrackOBotAPI.isLogged()

        loginButton.title = TrackOBotAPI.isLogged() ?
            NSLocalizedString("Logout", comment: "") : NSLocalizedString("Login", comment: "")
    }
    
    @IBAction func checkboxClicked(_ sender: NSButton) {
        if sender == synchronizeMatches {
            Settings.trackobotSynchronizeMatches = synchronizeMatches.state == .on
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if TrackOBotAPI.isLogged() {
            let msg = NSLocalizedString("Are you sure you want to disconnect from Track-o-Bot ?",
                                        comment: "")
            if NSAlert.show(style: .informational, message: msg) {
                TrackOBotAPI.logout()
                self.reloadStates()
            }
        } else {
            trackobotLogin = TrackOBotLogin(windowNibName: NSNib.Name(rawValue: "TrackOBotLogin"))
            if let trackobotLogin = trackobotLogin {
                self.view.window?.beginSheet(trackobotLogin.window!) { [weak self] (response) in
                    if response == NSApplication.ModalResponse.OK {
                        self?.reloadStates()
                    }
                }
            }
        }
    }
    
    @IBAction func openTrackobotProfile(_ sender: Any) {
        try? TrackOBotAPI.openProfile()
    }
}

// MARK: - MASPreferencesViewController
extension TrackOBotPreferences: MASPreferencesViewController {
    var viewIdentifier: String {
        return "trackobot"
    }
    
    var toolbarItemImage: NSImage? {
        return NSImage(named: NSImage.Name(rawValue: "trackobot_icon"))
    }
    
    var toolbarItemLabel: String? {
        return "Track-o-Bot"
    }
}
