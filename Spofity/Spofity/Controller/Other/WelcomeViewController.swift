//
//  WelcomeViewController.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let signInbutton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("Login In Spotify", for: .normal)
        btn.setTitleColor(.brown, for: .normal)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

         title = "Spotify"
        view.backgroundColor = .systemPink
        view.addSubview(signInbutton)
        signInbutton.addTarget(self, action: #selector(signedInButtonTapped), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInbutton.frame = CGRect(x: 10, y: 1, width: 200, height: 50)
    }
    
    @objc func signedInButtonTapped(){
       let vc  = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

  
}
