//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spofity
//
//  Created by Pallavi on 01/08/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    private let playlistCoverImage : UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 8
        imageview.image = UIImage(systemName: "photo")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let playlistNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 18, weight: .regular)
        name.numberOfLines = 0
        name.textAlignment = .left
        return name
    }()
   
    private let creatorNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15, weight: .thin)
        name.numberOfLines = 0
        name.textAlignment = .left

        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(playlistCoverImage)

        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .secondarySystemBackground

        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height - 35, width: contentView.width - 6, height: 30)

        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height - 70, width: contentView.width - 6, height: 30)
        let imagesize = contentView.height - 70
        playlistCoverImage.frame = CGRect(x: (contentView.width - imagesize)/2, y: 3, width: imagesize, height: imagesize)
        
        
        
    }
    func configaureViewmodel(with ViewModel:FeaturedPlaylistViewModel) {
        playlistNameLabel.text = ViewModel.name
        creatorNameLabel.text = ViewModel.creatorName
        playlistCoverImage.sd_setImage(with: ViewModel.artworkURL, completed: nil)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImage.image = nil
    }
}
