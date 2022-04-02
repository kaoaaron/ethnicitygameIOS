//
//  ProfileViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-03-19.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var ethnicityTextField: UITextField!

    var ethnicities = ["Other Asian"]
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        currentImage.image = nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            currentImage.image = image
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
