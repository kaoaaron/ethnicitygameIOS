//
//  PlayMenuViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-06.
//

import UIKit
import SwiftUI

class PlayMenuViewController: UIViewController {

    @IBOutlet weak var allButton: UIButton!
    var ethnicities : [String] = []
    var celebrities : [Celebrities] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getEthnicityData(from: "https://5d210z0x0a.execute-api.us-east-1.amazonaws.com/dev/ethnicities/asian")
        getCelebrityData(from: "https://5d210z0x0a.execute-api.us-east-1.amazonaws.com/dev/ethnicities/asian/celebrity")
    }
    
    private func getEthnicityData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: EthResponse?
            do {
                result = try JSONDecoder().decode(EthResponse.self, from: data)
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
        }).resume()
    }
    
    private func getCelebrityData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: CelResponse?
            do {
                result = try JSONDecoder().decode(CelResponse.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.celebrities = json.celebrities
        }).resume()
    }
    
    struct EthResponse: Codable {
        let ethnicities: [Ethnicities]
        let statusCode: Int
    }
    
    struct Ethnicities: Codable {
        let ethnicity: String
    }
    
    struct CelResponse: Codable {
        let statusCode: Int
        let celebrities: [Celebrities]
    }
    
    struct Celebrities: Codable {
        let name: String
        let image: String
        let nativeName: String
        let occupation: String
        let ethnicity: String
    }
    
    @IBAction func allButtonPressed(_ sender: Any) {
        let vc = UIHostingController(rootView: PlayOptionsViewScreen(gameManagerVM: GameManagerVM(ethnicities: self.ethnicities, celebrities: self.celebrities.shuffled())))
        present(vc, animated: true)
    }
    
    @IBAction func celebrityListButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "celeb", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CelebrityListViewController
        vc.celebrityList = self.celebrities
    }
}
