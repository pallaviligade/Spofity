//
//  HomeViewController.swift
//  Spofity
//
//  Created by Pallavi on 12/07/21.
//

import UIKit

enum BrowsSectionType {
    case newRelease(viewModel:[NewReleaseCellViewModel])
    case featuredPlaylist(viewModel:[NewReleaseCellViewModel])
    case recommendedTrack(viewModel:[NewReleaseCellViewModel])
}

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
        //self.view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(tappedSettings))
      
        configaureCollectionView()
        view.addSubview(spinner)
        fecthData()

    }
    private var sections = [BrowsSectionType]()
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    private func configaureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell"
        )
        collectionView.register(NewRelaseCollectionViewCell.self, forCellWithReuseIdentifier: NewRelaseCollectionViewCell.identifier
        )
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        )
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
  
    
  private func fecthData(){
    let group = DispatchGroup()
    group.enter()
    group.enter()
    group.enter()
    print("start api call...")
    // new release
    var newRelease:NewRealseResponse?
    var featuredPlaylist:FeaturedPlaylistResponse?
    var recommededResponse:RecimmendationResponse?
    APIManager.shared.getNewRelease { result in
        defer{
            group.leave()
        }
        switch result{
            case .success(let model):
                newRelease = model
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
           
        }
    }
    // Featured playlist,
    APIManager.shared.getFeaturedPlaylist { result in
        defer{
            group.leave()
        }
        switch result{
            case .success(let model):
                featuredPlaylist = model
                break
            case .failure(let error):
                print(error.localizedDescription)

                break
        }
    }
    // Recommended tracks,
    APIManager.shared.getRecommendationGenres { result in
      
        switch result{
            case .success(let model):
                guard  let geners = model.genres else {return}
                var seeds = Set<String>()
                while seeds.count < 5 { // Get 5 random elements
                    if let random = geners.randomElement() {
                    seeds.insert(random)
                  }
                }
                APIManager.shared.getrecommendations(geners: seeds) { recommededResults  in
                    defer{
                    group.leave()
                    }
                    switch recommededResults{
                        case .success(let model):
                            recommededResponse = model
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            break
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
        }
    }
    group.notify(queue: .main) {
        guard let release = newRelease?.albums.items,
              let playlist = featuredPlaylist?.playlists.items,
              let tracks = recommededResponse?.tracks
        else{
            return
        }
        
        self.configaureModels(NewAlbum: release, playlist: playlist, tracks: tracks)
        
    }
   
  }
    private func configaureModels(NewAlbum:[Album],playlist:[Playlist],tracks:[AudioTrack]){
        print(NewAlbum.count)
        print(playlist.count)
        print(tracks.count)
        // convert every model into viewmodel using compact
        sections.append(.newRelease(viewModel: NewAlbum.compactMap({
            return NewReleaseCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberofTracks: $0.total_tracks, artistName: $0.artists.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylist(viewModel: []))
        sections.append(.recommendedTrack(viewModel: []))
        collectionView.reloadData()
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
        let type = sections[section]
        switch type {
            case .newRelease(let viewmodels):
                return viewmodels.count
            case .featuredPlaylist(let viewmodels):
                return viewmodels.count
            case .recommendedTrack(let viewmodels):
                return viewmodels.count
                
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            case .newRelease(let viewmodels):
                guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewRelaseCollectionViewCell.identifier, for: indexPath) as? NewRelaseCollectionViewCell else{
                    return UICollectionViewCell()
                }
                let viewmodel = viewmodels[indexPath.row]
                cell.configaureViewmodel(with: viewmodel)
                return cell
            case .featuredPlaylist(let viewmodels):
                guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else{
                    return UICollectionViewCell()
                }
                cell.backgroundColor = .blue
                return cell
            case .recommendedTrack(let viewmodels):
                guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else{
                    return UICollectionViewCell()
                }
                cell.backgroundColor = .orange
                return cell
        }
    
    }
    
     static func createSectionLayout(section:Int) -> NSCollectionLayoutSection{
        switch section {
            case 0:
                // item
                  let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                  item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                  // Verticalgroup inside horiztal group
                  let Verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 3)
                  let Horizontallgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), subitem: Verticalgroup, count: 1)
                  // section
                  let section = NSCollectionLayoutSection(group: Horizontallgroup)
                  section.orthogonalScrollingBehavior = .groupPaging
                  return section
            case 1:
                // item
                  let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(250)))
                  item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                  // Verticalgroup inside horiztal group
                  
                
              let Verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem: item, count: 2)
                
                let Horizontallgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(400)), subitem: Verticalgroup, count: 1)
                  // section
                  let section = NSCollectionLayoutSection(group: Horizontallgroup)
                  section.orthogonalScrollingBehavior = .groupPaging
                  return section
            case 2:
                // item
                  let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                  item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitem: item, count: 1)
                  // section
                
                  let section = NSCollectionLayoutSection(group: group)
                  return section
            default:
                // item
                  let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                  item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                  let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 1)
                 
                  // section
                  let section = NSCollectionLayoutSection(group: group)
                  return section
        }
    }
}
