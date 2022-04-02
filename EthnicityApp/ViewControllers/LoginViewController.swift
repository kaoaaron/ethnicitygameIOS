//
//  LoginViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-10.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        FormStyles.styleFilledButton(loginButton, Constants.ButtonColors.loginColor)
        FormStyles.styleFilledButton(fbLoginButton, Constants.ButtonColors.fbLoginColor)
        FormStyles.styleFilledButton(googleLoginButton, Constants.ButtonColors.googleLoginColor)
        FormStyles.styleFilledButton(signUpButton, Constants.ButtonColors.signupEmailColor)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                    self.transitionToProfile()
                } else {
                    self.errorLabel.text = "Email not yet verified"
                    self.errorLabel.alpha = 1
                }
            }
        }
        
    }
    
    
    @IBAction func facebookTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            print("yes")
            
            guard let accessToken = AccessToken.current?.tokenString else {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            
            Auth.auth().signIn(with: credential) {
                (user, error) in
                print("logged in")
                self.transitionToProfile()
            }
        }
    }
    
    @IBAction func googleTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let err = error {
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) {
                (user, error) in
                print("logged in")
                self.transitionToProfile()
            }
        }
        
    }

    func transitionToProfile() {
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storeboard.profileViewController) as? ProfileViewController
    
        view.window?.rootViewController = profileViewController
        view.window?.makeKeyAndVisible()
    }
}
