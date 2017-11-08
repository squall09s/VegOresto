//
//  CommentTableViewCell.swift
//  VegOresto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 05/01/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import SDWebImage
import Keys

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var varIB_label_comment: UILabel?

    @IBOutlet var varIB_subtitle_label: UILabel!

    @IBOutlet var varIB_starRating0: UIImageView?
    @IBOutlet var varIB_starRating1: UIImageView?
    @IBOutlet var varIB_starRating2: UIImageView?
    @IBOutlet var varIB_starRating3: UIImageView?
    @IBOutlet var varIB_starRating4: UIImageView?

    @IBOutlet var varIB_imageComment: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setImage(url: String?) {

        if let _url = url {

        self.varIB_imageComment?.isHidden = false

        if let _url = URL(string: _url ) {

            let sdDownloader = SDWebImageDownloader.shared()
            sdDownloader.username = APIConfig.apiBasicAuthLogin
            sdDownloader.password = APIConfig.apiBasicAuthPassword

            sdDownloader.downloadImage(with: _url, options: .continueInBackground, progress: { (_, _, _) in

            }, completed: { (image, _, _, _) in

                self.varIB_imageComment?.image = image
                self.varIB_imageComment?.contentMode = .scaleAspectFit
            })

        } else {

            self.varIB_imageComment?.isHidden = true

        }
        }

    }

    func setRating(ratting: Int?) {

        self.varIB_starRating0?.image = UIImage(named: "img_favoris_star_off")
        self.varIB_starRating1?.image = UIImage(named: "img_favoris_star_off")
        self.varIB_starRating2?.image = UIImage(named: "img_favoris_star_off")
        self.varIB_starRating3?.image = UIImage(named: "img_favoris_star_off")
        self.varIB_starRating4?.image = UIImage(named: "img_favoris_star_off")

        if let _ratting = ratting {

            if _ratting > 0 {
                    self.varIB_starRating0?.image = UIImage(named: "img_favoris_star_on")
            }
            if _ratting > 1 {
                self.varIB_starRating1?.image = UIImage(named: "img_favoris_star_on")
            }
            if _ratting > 2 {
                self.varIB_starRating2?.image = UIImage(named: "img_favoris_star_on")
            }
            if _ratting > 3 {
                self.varIB_starRating3?.image = UIImage(named: "img_favoris_star_on")
            }
            if _ratting > 4 {
                self.varIB_starRating4?.image = UIImage(named: "img_favoris_star_on")
            }

        }

    }

}
