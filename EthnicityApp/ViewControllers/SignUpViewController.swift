//
//  SignUpViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-10.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import WebKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    

    func setUpElements() {
        errorLabel.alpha = 0
        FormStyles.styleFilledButton(createAccountButton, Constants.ButtonColors.loginColor)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateFields() -> String? {
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmCleanedPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedPassword != confirmCleanedPassword {
            return "Passwords do not match"
        }
        
        if FormValidation.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) {(result, err) in
                if err != nil {
                    self.showError("Email address already registered")
                } else{
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["uid": result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    
                    Auth.auth().currentUser?.sendEmailVerification {
                        (error) in
                        //
                    }
                    
                    //self.transitionToProfile()
                }
            }
            
            print("works")
        }
    }
    
    func showError (_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
//    func transitionToProfile() {
//        let profileViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storeboard.profileViewController) as? ProfileViewController
//
//        view.window?.rootViewController = profileViewController
//        view.window?.makeKeyAndVisible()
//    }

}
