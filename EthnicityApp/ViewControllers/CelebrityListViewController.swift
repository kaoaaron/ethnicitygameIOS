//
//  CelebrityListViewController.swift
//  EthnicityApp
//
//  Created by Aaron Kao on 2022-04-12.
//

import UIKit

class CelebrityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var celebrityList: [PlayMenuViewController.Celebrities] = []
    var celebrityInfo: PlayMenuViewController.Celebrities = PlayMenuViewController.Celebrities(name: "Aaron Kao", image: "", nativeName: "", occupation: "", ethnicity: "chinese")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.celebrityInfo = celebrityList[indexPath.row]
        performSegue(withIdentifier: "celebinfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = celebrityList[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CelebInfoViewController
        vc.celebrityInfo = self.celebrityInfo
    }
}

