//
//  CelebInfoViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-13.
//

import UIKit

class CelebInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var otherName: UILabel!
    @IBOutlet weak var ethnicity: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    var celebrityInfo : PlayMenuViewController.Celebrities = PlayMenuViewController.Celebrities(name: "Aaron Kao", image: "", nativeName: "", occupation: "", ethnicity: "chinese")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = celebrityInfo.name
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        imageView.load(url: URL(string: celebrityInfo.image)!)
        name.text = celebrityInfo.name
        name.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        name.textColor = UIColor.orange
        otherName.text = "Also known as: " + celebrityInfo.nativeName
        ethnicity.text = "Ethnicity: "  + celebrityInfo.ethnicity
        occupation.text = "Occupation: " + celebrityInfo.occupation
        otherName.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        ethnicity.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        occupation.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    }
    
}

extension UIImageView
{
    func load(url: URL) {
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
