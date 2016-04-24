// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIImage {
  enum Asset: String {
    case ClusterLarge = "clusterLarge"
    case ClusterMedium = "clusterMedium"
    case ClusterSmall = "clusterSmall"
    case Img_anotation_0 = "img_anotation_0"
    case Img_anotation_1 = "img_anotation_1"
    case Img_anotation_2 = "img_anotation_2"
    case Img_anotation_lock = "img_anotation_lock"
    case Img_bt_back = "img_bt_back"
    case Img_bt_localisation = "img_bt_localisation"
    case Img_bt_localisation_black = "img_bt_localisation_black"
    case Img_bt_share = "img_bt_share"
    case Img_gluten_free_off = "img_gluten_free_off"
    case Img_gluten_free_off_white = "img_gluten_free_off_white"
    case Img_gluten_free_on = "img_gluten_free_on"
    case Img_header = "img_header"
    case Img_ic_accueil_bt_1 = "img_ic_accueil_bt_1"
    case Img_ic_accueil_bt_2 = "img_ic_accueil_bt_2"
    case Img_ic_maps = "img_ic_maps"
    case Img_ic_maps_black = "img_ic_maps_black"
    case Img_ic_more = "img_ic_more"
    case Img_ic_more_black = "img_ic_more_black"
    case Img_ic_network = "img_ic_network"
    case Img_ic_phone = "img_ic_phone"
    case Img_ic_phone_black = "img_ic_phone_black"
    case Img_no_images = "img_no_images"
    case Img_vegan_off = "img_vegan_off"
    case Img_vegan_off_white = "img_vegan_off_white"
    case Img_vegan_on = "img_vegan_on"

    var image: UIImage {
      return UIImage(asset: self)
    }
  }

  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
