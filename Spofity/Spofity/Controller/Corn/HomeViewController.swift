//
//  HomeViewController.swift
//  Spofity
//
//  Created by Pallavi on 12/07/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var collectionView:UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { SectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: SectionIndex)
    }
    )
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(tappedSettings))
      
        configaureCollectionView()
        view.addSubview(spinner)
        fecthData()

    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    private func configaureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection{
      // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        // group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), subitem: item, count: 1)
        // section
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
  private func fecthData(){
    // Featured playlist,Recommended tracks,new release
    APIManager.shared.getRecommendationGenres { result in
        switch result{
            case .success(let model):
                let geners = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 { // Get 5 random elements
                    if let random = geners.randomElement() {
                    seeds.insert(random)
                    }
                }
                APIManager.shared.getrecommendations(geners: seeds) { _  in
                
                }
                
                break
            case .failure(let error):
                break
        }
      
    }
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
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }
    
    
}
