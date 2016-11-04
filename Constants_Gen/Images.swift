// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum Asset: String {
  case clusterLarge = "clusterLarge"
  case clusterMedium = "clusterMedium"
  case clusterSmall = "clusterSmall"
  case imgAnotation0 = "img_anotation_0"
  case imgAnotation1 = "img_anotation_1"
  case imgAnotation2 = "img_anotation_2"
  case imgAnotationLock = "img_anotation_lock"
  case imgBtBack = "img_bt_back"
  case imgBtFbOrangeOff = "img_bt_fb_orange_off"
  case imgBtFbOrangeOn = "img_bt_fb_orange_on"
  case imgBtLocalisation = "img_bt_localisation"
  case imgBtLocalisationBlack = "img_bt_localisation_black"
  case imgBtMailOrangeOff = "img_bt_mail_orange_off"
  case imgBtMailOrangeOn = "img_bt_mail_orange_on"
  case imgBtMapsOrangeOff = "img_bt_maps_orange_off"
  case imgBtMapsOrangeOn = "img_bt_maps_orange_on"
  case imgBtMenu = "img_bt_menu"
  case imgBtOrangeNext = "img_bt_orange_next"
  case imgBtOrangeShare = "img_bt_orange_share"
  case imgBtReturnOrange = "img_bt_return_orange"
  case imgBtShare = "img_bt_share"
  case imgBtTelOrangeOff = "img_bt_tel_orange_off"
  case imgBtTelOrangeOn = "img_bt_tel_orange_on"
  case imgBtWebOrangeOff = "img_bt_web_orange_off"
  case imgBtWebOrangeOn = "img_bt_web_orange_on"
  case imgChevrons = "img_chevrons"
  case imgDetailResto = "img_detail_resto"
  case imgFavoris0 = "img_favoris_0"
  case imgFavoris1 = "img_favoris_1"
  case imgFavoris2 = "img_favoris_2"
  case imgFavorisOff = "img_favoris_off"
  case imgFavorisOn = "img_favoris_on"
  case imgFavorisOn0 = "img_favoris_on_0"
  case imgFavorisOn1 = "img_favoris_on_1"
  case imgFavorisOn2 = "img_favoris_on_2"
  case imgFavorisOrangeOff = "img_favoris_orange_off"
  case imgFavorisOrangeOn = "img_favoris_orange_on"
  case imgFavorisStarOff = "img_favoris_star_off"
  case imgFavorisStarOn = "img_favoris_star_on"
  case imgFavorisWh = "img_favoris_wh"
  case imgGlutenFreeOff = "img_gluten_free_off"
  case imgGlutenFreeOffWhite = "img_gluten_free_off_white"
  case imgGlutenFreeOn = "img_gluten_free_on"
  case imgHeader = "img_header"
  case imgIcAccueilBt1 = "img_ic_accueil_bt_1"
  case imgIcAccueilBt2 = "img_ic_accueil_bt_2"
  case imgIcMaps = "img_ic_maps"
  case imgIcMapsBlack = "img_ic_maps_black"
  case imgIcMore = "img_ic_more"
  case imgIcMoreBlack = "img_ic_more_black"
  case imgIcNetwork = "img_ic_network"
  case imgIcPhone = "img_ic_phone"
  case imgIcPhoneBlack = "img_ic_phone_black"
  case imgLogo = "img_logo"
  case imgMenu0 = "img_menu_0"
  case imgMenu1 = "img_menu_1"
  case imgMenu2 = "img_menu_2"
  case imgMenu3 = "img_menu_3"
  case imgMenuBg0 = "img_menu_bg_0"
  case imgMenuBtNextWhite = "img_menu_bt_next_white"
  case imgMenuCell4 = "img_menu_cell_4"
  case imgMenuCellPoint = "img_menu_cell_point"
  case imgMenuFavoris = "img_menu_favoris"
  case imgMenuRestos = "img_menu_restos"
  case imgNoImages = "img_no_images"
  case imgSeparateurDetailResto = "img_separateur_detail_resto"
  case imgSettingsDoc = "img_settings_doc"
  case imgSettingsMail = "img_settings_mail"
  case imgVeganOff = "img_vegan_off"
  case imgVeganOffWhite = "img_vegan_off_white"
  case imgVeganOn = "img_vegan_on"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
