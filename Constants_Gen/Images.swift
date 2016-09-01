// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

enum Asset: String {
  case ClusterLarge = "clusterLarge"
  case ClusterMedium = "clusterMedium"
  case ClusterSmall = "clusterSmall"
  case Img_anotation_0 = "img_anotation_0"
  case Img_anotation_1 = "img_anotation_1"
  case Img_anotation_2 = "img_anotation_2"
  case Img_anotation_lock = "img_anotation_lock"
  case Img_bt_back = "img_bt_back"
  case Img_bt_fb_orange_off = "img_bt_fb_orange_off"
  case Img_bt_fb_orange_on = "img_bt_fb_orange_on"
  case Img_bt_localisation = "img_bt_localisation"
  case Img_bt_localisation_black = "img_bt_localisation_black"
  case Img_bt_mail_orange_off = "img_bt_mail_orange_off"
  case Img_bt_mail_orange_on = "img_bt_mail_orange_on"
  case Img_bt_maps_orange_off = "img_bt_maps_orange_off"
  case Img_bt_maps_orange_on = "img_bt_maps_orange_on"
  case Img_bt_menu = "img_bt_menu"
  case Img_bt_orange_next = "img_bt_orange_next"
  case Img_bt_orange_share = "img_bt_orange_share"
  case Img_bt_return_orange = "img_bt_return_orange"
  case Img_bt_share = "img_bt_share"
  case Img_bt_tel_orange_off = "img_bt_tel_orange_off"
  case Img_bt_tel_orange_on = "img_bt_tel_orange_on"
  case Img_bt_web_orange_off = "img_bt_web_orange_off"
  case Img_bt_web_orange_on = "img_bt_web_orange_on"
  case Img_chevrons = "img_chevrons"
  case Img_detail_resto = "img_detail_resto"
  case Img_favoris_0 = "img_favoris_0"
  case Img_favoris_1 = "img_favoris_1"
  case Img_favoris_2 = "img_favoris_2"
  case Img_favoris_off = "img_favoris_off"
  case Img_favoris_on = "img_favoris_on"
  case Img_favoris_on_0 = "img_favoris_on_0"
  case Img_favoris_on_1 = "img_favoris_on_1"
  case Img_favoris_on_2 = "img_favoris_on_2"
  case Img_favoris_orange_off = "img_favoris_orange_off"
  case Img_favoris_orange_on = "img_favoris_orange_on"
  case Img_favoris_star_off = "img_favoris_star_off"
  case Img_favoris_star_on = "img_favoris_star_on"
  case Img_favoris_wh = "img_favoris_wh"
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
  case Img_logo = "img_logo"
  case Img_menu_0 = "img_menu_0"
  case Img_menu_1 = "img_menu_1"
  case Img_menu_2 = "img_menu_2"
  case Img_menu_3 = "img_menu_3"
  case Img_menu_bg_0 = "img_menu_bg_0"
  case Img_menu_bt_next_white = "img_menu_bt_next_white"
  case Img_menu_cell_4 = "img_menu_cell_4"
  case Img_menu_cell_point = "img_menu_cell_point"
  case Img_menu_favoris = "img_menu_favoris"
  case Img_menu_restos = "img_menu_restos"
  case Img_no_images = "img_no_images"
  case Img_separateur_detail_resto = "img_separateur_detail_resto"
  case Img_settings_doc = "img_settings_doc"
  case Img_settings_mail = "img_settings_mail"
  case Img_vegan_off = "img_vegan_off"
  case Img_vegan_off_white = "img_vegan_off_white"
  case Img_vegan_on = "img_vegan_on"

  var image: Image {
    return Image(asset: self)
  }
}

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
