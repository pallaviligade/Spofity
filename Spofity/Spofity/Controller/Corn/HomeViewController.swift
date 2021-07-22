//
//  HomeViewController.swift
//  Spofity
//
//  Created by Pallavi on 12/07/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(tappedSettings))

    }
    @objc func tappedSettings(){
        
        DispatchQueue.main.async {
            let vc = SettingsViewController()
            vc.title = "Setting"
            vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    

}
