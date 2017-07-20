//
//  LoginViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/20/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
//use FIRUser to refer to the FirebaseAuth.User type

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}
extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        
        guard let user = user
            else {  return  }
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // handle new user
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
        }
        
        //            UserService.show(forUID: user.uid) { (user) in
        //            let ref = Database.database().reference().child("users").child(user!.uid)
        //            ref.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
        //                if let user = User(snapshot: snapshot) {
        //                    User.setCurrent(user)
        //
        //                    let initialViewController = UIStoryboard.initialViewController(for: .main)
        //                    self.view.window?.rootViewController = initialViewController
        //                    self.view.window?.makeKeyAndVisible()
        //                } else {
        //                    // 1
        //                    self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
        //                }
        //            })
        //        }
    }
}


