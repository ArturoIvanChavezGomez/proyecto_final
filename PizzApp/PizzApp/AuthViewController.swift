//
//  AuthViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 23/06/21.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FirebaseFirestore
import IQKeyboardManagerSwift

class AuthViewController: UIViewController {
    
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var authEmail: String?
    var authProvider: ProviderType?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStackView.isHidden = true
        authStackView.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toMainSegue", sender: self)
        } else {
            imageStackView.isHidden = false
            authStackView.isHidden = false
            googleButton.layer.borderWidth = 1.5
            googleButton.layer.borderColor = #colorLiteral(red: 0.8655124903, green: 0.390791595, blue: 0, alpha: 1)
            facebookButton.layer.borderWidth = 1.5
            facebookButton.layer.borderColor = #colorLiteral(red: 0.8655124903, green: 0.390791595, blue: 0, alpha: 1)
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "onboarding") == false {
                performSegue(withIdentifier: "toOnboardingSegue", sender: self)
            }
        }
    }
    
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                self.goToHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    @IBAction func logInButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                self.goToHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    @IBAction func googleButtonAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential) { (result, error) in
                    self.goToHome(result: result, error: error, provider: .facebook)
                }
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
    
    private func goToHome(result: AuthDataResult?, error: Error?, provider: ProviderType) {
        if let result = result, error == nil {
            let defaults = UserDefaults.standard
            defaults.set(result.user.email!, forKey: "email")
            defaults.set(provider.rawValue, forKey: "provider")
            performSegue(withIdentifier: "toMainSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil {
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                self.goToHome(result: result, error: error, provider: .google)
            }
        }
    }
}
