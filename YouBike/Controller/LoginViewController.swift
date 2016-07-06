//
//  LoginViewController.swift
//  YouBike
//
//  Created by Sarah on 5/9/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController{

    @IBOutlet weak var bikeLogoView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var buttonStylishView: UIView!
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBAction func loginButton(sender: AnyObject) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        let readPermissions = ["email", "public_profile"]
        
        fbLoginManager.logInWithReadPermissions(readPermissions, fromViewController: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if fbloginresult.isCancelled{
                    fbLoginManager.logOut()
                }else if(fbloginresult.grantedPermissions.contains("email")){
                    self.loginedFB()
                    self.getFacebookUserDetail()
                }else{
                    fbLoginManager.logOut()
                }
            }
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupYouBikeLabel()
        setupBikeLogo()
        setupLoginButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupYouBikeLabel(){
        
        let attributes = [NSStrokeWidthAttributeName: -2.0,
                          NSStrokeColorAttributeName: UIColor.ybkPaleColor(),
                          NSForegroundColorAttributeName: UIColor.ybkCharcoalGreyColor()];
        
        logoLabel.attributedText = NSAttributedString(string: "YouBike", attributes: attributes)
    }
    
    func setupBackground(){
        guard let backgroundImage = UIImage(named: "pattern-wood.png") else {
            print("backgroundImageis nil")
            return
        }
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
        
    func setupLoginButton() {
        logInButton.backgroundColor = UIColor.ybkDenimBlueColor()
        logInButton.setTitle(NSLocalizedString("LoginWithFacebook", comment: ""), forState: UIControlState.Normal)
        logInButton.setTitleColor(UIColor.ybkWhiteColor(), forState: UIControlState.Normal)
        logInButton.titleLabel?.font = UIFont.ybkTextStyleHelvetica(20)
        logInButton.layer.cornerRadius = 10.0
        
        buttonStylishView.userInteractionEnabled = false
    }
    
    func setupBikeLogo(){
    
        bikeLogoView.backgroundColor = UIColor.ybkPaleTwoColor()
        bikeLogoView.layer.borderColor = UIColor.ybkCharcoalGreyColor().CGColor
        bikeLogoView.layer.borderWidth = 1.0
        bikeLogoView.layer.cornerRadius = 40
    }
    
    // MARK: - FaceBook Login
    
    func loginedFB(){
        let tabView = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! TabBarController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.8, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
            appDelegate.window?.rootViewController = tabView
            }, completion: nil)
    }
    
    func getFacebookUserDetail(){
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email, link"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let userFirstName: String = (result.objectForKey("first_name") as? String)!
            let userLastName: String = (result.objectForKey("last_name") as? String)!
            let userEmail: String = (result.objectForKey("email") as? String)!
            let userPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            let userPageURL: String = (result.objectForKey("link") as? String)!
        
            let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(userFirstName, forKey: "first_name")
            defaults.setObject(userLastName, forKey: "last_name")
            defaults.setObject(userEmail, forKey: "email")
            defaults.setObject(userPageURL, forKey: "link")
            defaults.setObject(userPictureURL, forKey: "profile_picture")
            
            defaults.synchronize()
        }
    }

    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
