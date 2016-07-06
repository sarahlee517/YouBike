//
//  ProfileViewController.swift
//  YouBike
//
//  Created by Sarah on 5/10/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SafariServices

class ProfileViewController: UIViewController, SFSafariViewControllerDelegate{

    @IBAction func logoutButton(sender: AnyObject) {
        logoutFacebook()
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicBorder: UIView!
    @IBOutlet weak var buttonStylishView: UIView!
    @IBOutlet weak var facebookPageButton: UIButton!
    
    @IBAction func facebookPageButtonDidClicked(sender: AnyObject) {
        
        guard let userPageURLString = NSUserDefaults.standardUserDefaults().objectForKey("link") as? String else { return }
        guard let userPageURL = NSURL(string: userPageURLString) else { return }
        let svc = SFSafariViewController(URL: userPageURL)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    
    }
    private let shadowLayer = CAShapeLayer()
    private let roundedLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupProfilePicBorder()
        fetchUserDetail()
        setupLoginButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCardView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupBackground(){
        guard let backgroundImage = UIImage(named: "pattern-wood.png") else {
            print("pattern-wood.png is nil")
            return
        }
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
    }

    func setupProfilePicBorder(){
        profilePicBorder.backgroundColor = UIColor.ybkWhiteColor()
        profilePicBorder.layer.opacity = 0.3
        profilePicBorder.layer.cornerRadius = 75
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupCardView() {
        
        let roundedPath = UIBezierPath(
            roundedRect: cardView.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight ],
            cornerRadii: CGSize(width: 20.0, height: 20.0)
        )
        
        cardView.layer.backgroundColor = UIColor.clearColor().CGColor
 
        shadowLayer.frame = cardView.bounds
        shadowLayer.shadowPath = roundedPath.CGPath
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 2.0
        
        roundedLayer.frame = cardView.bounds
        roundedLayer.path = roundedPath.CGPath
        roundedLayer.fillColor = UIColor.ybkPaleColor().CGColor
    
        cardView.layer.insertSublayer(roundedLayer, atIndex: 0)
        cardView.layer.insertSublayer(shadowLayer, atIndex: 0)

    }
    
    
    func fetchUserDetail(){
        
        guard let userFirstName = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as? String,
            let userLastName = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as? String,
            let userPictureURL = NSUserDefaults.standardUserDefaults().objectForKey("profile_picture") as? String,
            let url = NSURL(string: userPictureURL),
            let data = NSData(contentsOfURL: url)
        else { return }
        
        
        
        self.userNameLabel.text = "\(userLastName) \(userFirstName)"
        self.userNameLabel.font = UIFont.ybkTextStyleHelvetica(50)
        self.userProfileImage.image = UIImage(data: data)
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.bounds.height / 2
        self.userProfileImage.clipsToBounds = true


    }
    
    func setupLoginButton() {
        facebookPageButton.backgroundColor = UIColor.ybkDenimBlueColor()
        facebookPageButton.setTitle(NSLocalizedString("FacebookPage", comment: ""), forState: UIControlState.Normal)
        facebookPageButton.setTitleColor(UIColor.ybkWhiteColor(), forState: UIControlState.Normal)
        facebookPageButton.titleLabel?.font = UIFont.ybkTextStyleHelvetica(20)
        facebookPageButton.layer.cornerRadius = 10.0
        
        buttonStylishView.userInteractionEnabled = false
    }

    
    func logoutFacebook(){
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            appDelegate.window?.rootViewController = loginView
            }, completion: nil)
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
