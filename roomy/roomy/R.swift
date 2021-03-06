//
//  R.swift
//  roomy
//
//  Created by Ryan Liszewski on 4/11/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//


struct R {
    
    struct Parse {
        struct Key{
            static let StatusMessage = "status_message"
        }
    }
    
    struct Header {
        static let home = "Home"
        static let notHome = "Not Home"
    }
    struct Identifier {
        struct Cell {
            static let homeTableViewCell = "HomeTableViewCell"
            static let homeCollectionViewCell = "HomeCollectionViewCell"
            static let StatusTableViewCell = "StatusTableViewCell"
        }
        struct Storyboard {
            static let loginAndSignUp = "Main"
            static let tabBar = "TabBar"
            static let messaging = "Messaging"
            static let Status = "Status"
        }
        struct ViewController {
            static let tabBarViewController = "TabBarController"
            static let updateStatusViewController = "UpdateStatusViewController"
            static let UserSignUpViewController = "UserSignUpViewController"
            static let UserLoginInViewController = "UserLoginViewController"
            static let HouseLoginViewController = "HouseLoginViewController"
            static let CreatHouseViewController = "CreatHouseViewController"
        }
        struct Segue {
            static let WelcomeToRoomySegue = "WelcomeToRoomySegue"
            static let TabBarController = "TabBarControllerSegue"
            static let SettingsSegue = "SettingsControllerSegue"
        }
    }
    struct TabBarController {
        struct SelectedIndex {
            static let messagingViewController = 1 
        }
    }
    
    struct Notifications {
        struct Messages {
            static let title = "Messages"
        }
    }
}

