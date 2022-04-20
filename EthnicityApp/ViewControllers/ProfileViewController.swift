//
//  ProfileViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var ethnicityTextField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var factField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    var ethnicities: [String] = []
    var imageurl:URL = URL(string: "/")!
    let userID = Auth.auth().currentUser!.uid
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser!.uid)
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        ethnicityTextField.inputView = pickerView
        
        let url = "https://5d210z0x0a.execute-api.us-east-1.amazonaws.com/dev/ethnicities/asian"
        getEthnicityData(from: url)
        setUpElements()
    }
    
    private func setUpElements() {
        errorLabel.alpha = 0
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(userID)
        
        ref.getData(maxSize: 1024 * 1024 * 5, completion: {data, error in
            if let error = error {
                self.currentImage.image = UIImage(named: "noimage")
            } else {
                self.currentImage.image = UIImage(data: data!)
            }
        })
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        docRef.getDocument(completion: {snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("blah fail")
                return
            }
            
            let ethnicity = data["ethnicity"]
            let name = data["name"]
            let age = data["age"]
            let fact = data["fact"]

            DispatchQueue.main.async {
                self.ethnicityTextField.text = ethnicity as? String
                self.nameField.text = name as? String
                self.ageField.text = age as? String
                self.factField.text = fact as? String
            }
        })
    }
    
    private func getEthnicityData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            print(json.statusCode)
            
            for ethnicity in json.ethnicities {
                self.ethnicities.append(ethnicity.ethnicity)
            }
            print(json.ethnicities[0].ethnicity)
        }).resume()
    }
    
    struct Response: Codable {
        let ethnicities: [Ethnicities]
        let statusCode: Int
    }
    
    struct Ethnicities: Codable {
        let ethnicity: String
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        print("works?")
        
        let name = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = ageField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let fact = factField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let ethnicity = ethnicityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ethnicity.isEmpty {
            errorLabel.alpha = 1
            errorLabel.textColor = UIColor.red
            errorLabel.text = "Error: Ethnicity is mandatory"
            UIView.animate(withDuration: 3, animations: {
                self.errorLabel.alpha = 0
            })
        } else {
            let db = Firestore.firestore()
            db.collection("users").document(self.userID).setData([
                "name": name, "age": age, "fact": fact, "ethnicity": ethnicity]) {
                    err in
                    if let err = err {
                        print(err)
                    } else{
                        self.errorLabel.alpha = 1
                        self.errorLabel.textColor = UIColor.green
                        self.errorLabel.text = "Data saved!"
                        UIView.animate(withDuration: 3, animations: {
                            self.errorLabel.alpha = 0
                        })
                    }
                    
                    self.storeImage()
                }
        }
    }
    
    private func storeImage() {
        if currentImage.image == UIImage(named: "noimage") {
            print("defualt image")
            return
        }
        
        let storage = Storage.storage()
        let data = Data()
        let storageRef = storage.reference()
        let localFile = self.imageurl
        let photoRef = storageRef.child(self.userID)
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil, completion: {(metadata, err) in
            guard let metadata = metadata else {
                print(self.imageurl)
                return
            }
            print("Photo Uploaded")
        })
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toplaymenu", sender: self)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func galleryButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        currentImage.image = UIImage(named: "noimage")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            currentImage.image = image
        }
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.imageurl = url
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ethnicities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ethnicities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ethnicityTextField.text = ethnicities[row]
        ethnicityTextField.resignFirstResponder()
    }
}
