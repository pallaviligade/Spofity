//
//  PlaylistViewController.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    private var viewModel = [RecommendedTrackCellViewModel]()
    private let playList:Playlist
    
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            return PlaylistViewController.createSectionLayout()
        })
    )
    init(playList:Playlist) {
        self.playList = playList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.title = playList.name
        view.addSubview(collectionView)
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier)
        collectionView.register(    PlaylistHeaderViewCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderViewCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        APIManager.shared.getPlaylistDetails(for: playList) { [weak self] result in
            switch result{
                case .success(let Model):
                    self?.viewModel = Model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(name: $0.track.name, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? "-"))
                    })
                    DispatchQueue.main.async { [weak self] in
                        
                        self?.collectionView.reloadData()
                    }
                    break
                    
                case .failure(let error):break
            }
        }
    }
    static func createSectionLayout() -> NSCollectionLayoutSection{
        // item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitem: item, count: 1)
        // section
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }
    
}
extension PlaylistViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.configaureViewmodel(with: viewModel[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderViewCollectionReusableView.identifier,for:indexPath) as? PlaylistHeaderViewCollectionReusableView else     {
            return UICollectionReusableView()
        }
        let headerviewmodel = PlaylistHeaderViewModel(playlistname: playList.name, ownername: playList.owner.display_name, discription: playList.description, artwork: URL(string: playList.images.first?.url ?? ""))
        header.configaure(with: headerviewmodel)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
