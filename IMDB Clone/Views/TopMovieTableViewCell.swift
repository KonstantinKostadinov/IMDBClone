//
//  TopMovieTableViewCell.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import UIKit

class TopMovieTableViewCell: UITableViewCell {
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingAndYearLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
