// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  typealias AssetColorTypeAlias = NSColor
  typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias AssetColorTypeAlias = UIColor
  typealias Image = UIImage
#endif

// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
typealias AssetType = ImageAsset

struct ImageAsset {
  fileprivate var name: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

struct ColorAsset {
  fileprivate var name: String

  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
  #endif
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
  static let addPost = ImageAsset(name: "add_post")
  static let error = ImageAsset(name: "error")
  static let imageResto0 = ImageAsset(name: "image_resto_0")
  static let imageResto1 = ImageAsset(name: "image_resto_1")
  static let imageRestoPlaceolder = ImageAsset(name: "image_resto_placeolder")
  static let imageRestoSliderCache = ImageAsset(name: "image_resto_slider_cache")
  static let imgAnotation0 = ImageAsset(name: "img_anotation_0")
  static let imgAnotation1 = ImageAsset(name: "img_anotation_1")
  static let imgAnotation2 = ImageAsset(name: "img_anotation_2")
  static let imgAnotationLock = ImageAsset(name: "img_anotation_lock")
  static let imgBtBack = ImageAsset(name: "img_bt_back")
  static let imgBtFbOrangeOff = ImageAsset(name: "img_bt_fb_orange_off")
  static let imgBtFbOrangeOn = ImageAsset(name: "img_bt_fb_orange_on")
  static let imgBtLocalisation = ImageAsset(name: "img_bt_localisation")
  static let imgBtLocalisationBlack = ImageAsset(name: "img_bt_localisation_black")
  static let imgBtMailOrangeOff = ImageAsset(name: "img_bt_mail_orange_off")
  static let imgBtMailOrangeOn = ImageAsset(name: "img_bt_mail_orange_on")
  static let imgBtMapsOrangeOff = ImageAsset(name: "img_bt_maps_orange_off")
  static let imgBtMapsOrangeOn = ImageAsset(name: "img_bt_maps_orange_on")
  static let imgBtMenu = ImageAsset(name: "img_bt_menu")
  static let imgBtOrangeNext = ImageAsset(name: "img_bt_orange_next")
  static let imgBtOrangeShare = ImageAsset(name: "img_bt_orange_share")
  static let imgBtReturnOrange = ImageAsset(name: "img_bt_return_orange")
  static let imgBtShare = ImageAsset(name: "img_bt_share")
  static let imgBtTelOrangeOff = ImageAsset(name: "img_bt_tel_orange_off")
  static let imgBtTelOrangeOn = ImageAsset(name: "img_bt_tel_orange_on")
  static let imgBtWebOrangeOff = ImageAsset(name: "img_bt_web_orange_off")
  static let imgBtWebOrangeOn = ImageAsset(name: "img_bt_web_orange_on")
  static let imgChevrons = ImageAsset(name: "img_chevrons")
  static let imgDetailResto = ImageAsset(name: "img_detail_resto")
  static let imgFavoris0 = ImageAsset(name: "img_favoris_0")
  static let imgFavoris1 = ImageAsset(name: "img_favoris_1")
  static let imgFavoris2 = ImageAsset(name: "img_favoris_2")
  static let imgFavorisOff = ImageAsset(name: "img_favoris_off")
  static let imgFavorisOn = ImageAsset(name: "img_favoris_on")
  static let imgFavorisOn0 = ImageAsset(name: "img_favoris_on_0")
  static let imgFavorisOn1 = ImageAsset(name: "img_favoris_on_1")
  static let imgFavorisOn2 = ImageAsset(name: "img_favoris_on_2")
  static let imgFavorisOrangeOff = ImageAsset(name: "img_favoris_orange_off")
  static let imgFavorisOrangeOn = ImageAsset(name: "img_favoris_orange_on")
  static let imgFavorisStarHalf = ImageAsset(name: "img_favoris_star_half")
  static let imgFavorisStarOff = ImageAsset(name: "img_favoris_star_off")
  static let imgFavorisStarOffWhite = ImageAsset(name: "img_favoris_star_off_white")
  static let imgFavorisStarOn = ImageAsset(name: "img_favoris_star_on")
  static let imgFavorisStarOnWhite = ImageAsset(name: "img_favoris_star_on_white")
  static let imgFavorisWh = ImageAsset(name: "img_favoris_wh")
  static let imgGlutenFreeOff = ImageAsset(name: "img_gluten_free_off")
  static let imgGlutenFreeOffWhite = ImageAsset(name: "img_gluten_free_off_white")
  static let imgGlutenFreeOn = ImageAsset(name: "img_gluten_free_on")
  static let imgHeader = ImageAsset(name: "img_header")
  static let imgIcAccueilBt1 = ImageAsset(name: "img_ic_accueil_bt_1")
  static let imgIcAccueilBt2 = ImageAsset(name: "img_ic_accueil_bt_2")
  static let imgIcMaps = ImageAsset(name: "img_ic_maps")
  static let imgIcMapsBlack = ImageAsset(name: "img_ic_maps_black")
  static let imgIcMore = ImageAsset(name: "img_ic_more")
  static let imgIcMoreBlack = ImageAsset(name: "img_ic_more_black")
  static let imgIcNetwork = ImageAsset(name: "img_ic_network")
  static let imgIcPhone = ImageAsset(name: "img_ic_phone")
  static let imgIcPhoneBlack = ImageAsset(name: "img_ic_phone_black")
  static let imgLogo = ImageAsset(name: "img_logo")
  static let imgMenu0 = ImageAsset(name: "img_menu_0")
  static let imgMenu1 = ImageAsset(name: "img_menu_1")
  static let imgMenu2 = ImageAsset(name: "img_menu_2")
  static let imgMenu3 = ImageAsset(name: "img_menu_3")
  static let imgMenuBg0 = ImageAsset(name: "img_menu_bg_0")
  static let imgMenuBtNextWhite = ImageAsset(name: "img_menu_bt_next_white")
  static let imgMenuCell4 = ImageAsset(name: "img_menu_cell_4")
  static let imgMenuCellPoint = ImageAsset(name: "img_menu_cell_point")
  static let imgMenuFavoris = ImageAsset(name: "img_menu_favoris")
  static let imgMenuRestos = ImageAsset(name: "img_menu_restos")
  static let imgNoImages = ImageAsset(name: "img_no_images")
  static let imgSeparateurDetailResto = ImageAsset(name: "img_separateur_detail_resto")
  static let imgSettingsDoc = ImageAsset(name: "img_settings_doc")
  static let imgSettingsMail = ImageAsset(name: "img_settings_mail")
  static let imgVeganOff = ImageAsset(name: "img_vegan_off")
  static let imgVeganOffWhite = ImageAsset(name: "img_vegan_off_white")
  static let imgVeganOn = ImageAsset(name: "img_vegan_on")
  static let pastilleV = ImageAsset(name: "PastilleV")

  // swiftlint:disable trailing_comma
  static let allColors: [ColorAsset] = [
  ]
  static let allImages: [ImageAsset] = [
    addPost,
    error,
    imageResto0,
    imageResto1,
    imageRestoPlaceolder,
    imageRestoSliderCache,
    imgAnotation0,
    imgAnotation1,
    imgAnotation2,
    imgAnotationLock,
    imgBtBack,
    imgBtFbOrangeOff,
    imgBtFbOrangeOn,
    imgBtLocalisation,
    imgBtLocalisationBlack,
    imgBtMailOrangeOff,
    imgBtMailOrangeOn,
    imgBtMapsOrangeOff,
    imgBtMapsOrangeOn,
    imgBtMenu,
    imgBtOrangeNext,
    imgBtOrangeShare,
    imgBtReturnOrange,
    imgBtShare,
    imgBtTelOrangeOff,
    imgBtTelOrangeOn,
    imgBtWebOrangeOff,
    imgBtWebOrangeOn,
    imgChevrons,
    imgDetailResto,
    imgFavoris0,
    imgFavoris1,
    imgFavoris2,
    imgFavorisOff,
    imgFavorisOn,
    imgFavorisOn0,
    imgFavorisOn1,
    imgFavorisOn2,
    imgFavorisOrangeOff,
    imgFavorisOrangeOn,
    imgFavorisStarHalf,
    imgFavorisStarOff,
    imgFavorisStarOffWhite,
    imgFavorisStarOn,
    imgFavorisStarOnWhite,
    imgFavorisWh,
    imgGlutenFreeOff,
    imgGlutenFreeOffWhite,
    imgGlutenFreeOn,
    imgHeader,
    imgIcAccueilBt1,
    imgIcAccueilBt2,
    imgIcMaps,
    imgIcMapsBlack,
    imgIcMore,
    imgIcMoreBlack,
    imgIcNetwork,
    imgIcPhone,
    imgIcPhoneBlack,
    imgLogo,
    imgMenu0,
    imgMenu1,
    imgMenu2,
    imgMenu3,
    imgMenuBg0,
    imgMenuBtNextWhite,
    imgMenuCell4,
    imgMenuCellPoint,
    imgMenuFavoris,
    imgMenuRestos,
    imgNoImages,
    imgSeparateurDetailResto,
    imgSettingsDoc,
    imgSettingsMail,
    imgVeganOff,
    imgVeganOffWhite,
    imgVeganOn,
    pastilleV,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX) || os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

extension AssetColorTypeAlias {
  #if swift(>=3.2)
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: asset.name, bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
  #endif
}

private final class BundleToken {}
