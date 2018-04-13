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
  static let icMenuInsta = ImageAsset(name: "ic_menu_insta")
  static let imgGlutenFreeOff = ImageAsset(name: "img_gluten_free_off")
  static let imgBtLocalisationBlack = ImageAsset(name: "img_bt_localisation_black")
  static let imgIcAccueilBt1 = ImageAsset(name: "img_ic_accueil_bt_1")
  static let imgFavorisOn2 = ImageAsset(name: "img_favoris_on_2")
  static let favorites = ImageAsset(name: "favorites")
  static let imgFavoris2 = ImageAsset(name: "img_favoris_2")
  static let imgGlutenFreeOn = ImageAsset(name: "img_gluten_free_on")
  static let addPost = ImageAsset(name: "add_post")
  static let imgIcMoreBlack = ImageAsset(name: "img_ic_more_black")
  static let imgMenuFavoris = ImageAsset(name: "img_menu_favoris")
  static let imgBtMailOrangeOff = ImageAsset(name: "img_bt_mail_orange_off")
  static let imgIcMapsBlack = ImageAsset(name: "img_ic_maps_black")
  static let error = ImageAsset(name: "error")
  static let imgAnotationLock = ImageAsset(name: "img_anotation_lock")
  static let imgBtTelOrangeOff = ImageAsset(name: "img_bt_tel_orange_off")
  static let imgMenuRestos = ImageAsset(name: "img_menu_restos")
  static let imgIcMaps = ImageAsset(name: "img_ic_maps")
  static let imageRestoPlaceolder = ImageAsset(name: "image_resto_placeolder")
  static let imgBtShare = ImageAsset(name: "img_bt_share")
  static let imgGlutenFreeOffWhite = ImageAsset(name: "img_gluten_free_off_white")
  static let imgFavorisOff = ImageAsset(name: "img_favoris_off")
  static let imgBtTelOrangeOn = ImageAsset(name: "img_bt_tel_orange_on")
  static let imgBtOrangeShare = ImageAsset(name: "img_bt_orange_share")
  static let imgAnotation0 = ImageAsset(name: "img_anotation_0")
  static let imgAnotation1 = ImageAsset(name: "img_anotation_1")
  static let imgIcPhoneBlack = ImageAsset(name: "img_ic_phone_black")
  static let imgFavorisStarOnWhite = ImageAsset(name: "img_favoris_star_on_white")
  static let icMenuFacebook = ImageAsset(name: "ic_menu_facebook")
  static let imgBtMapsOrangeOn = ImageAsset(name: "img_bt_maps_orange_on")
  static let imgMenuBg0 = ImageAsset(name: "img_menu_bg_0")
  static let pastilleV = ImageAsset(name: "PastilleV")
  static let imgMenu3 = ImageAsset(name: "img_menu_3")
  static let imgMenu2 = ImageAsset(name: "img_menu_2")
  static let rightChevron = ImageAsset(name: "right-chevron")
  static let imgBtMenu = ImageAsset(name: "img_bt_menu")
  static let imgFavorisStarHalf = ImageAsset(name: "img_favoris_star_half")
  static let imgBtMailOrangeOn = ImageAsset(name: "img_bt_mail_orange_on")
  static let imgVeganOn = ImageAsset(name: "img_vegan_on")
  static let imgMenuCell4 = ImageAsset(name: "img_menu_cell_4")
  static let icMenuTwitter = ImageAsset(name: "ic_menu_twitter")
  static let imgVeganOffWhite = ImageAsset(name: "img_vegan_off_white")
  static let imgBtWebOrangeOn = ImageAsset(name: "img_bt_web_orange_on")
  static let imgBtBack = ImageAsset(name: "img_bt_back")
  static let imgBtFbOrangeOff = ImageAsset(name: "img_bt_fb_orange_off")
  static let imgSeparateurDetailResto = ImageAsset(name: "img_separateur_detail_resto")
  static let leftChevron = ImageAsset(name: "left-chevron")
  static let imgFavorisOn = ImageAsset(name: "img_favoris_on")
  static let imgFavorisOrangeOn = ImageAsset(name: "img_favoris_orange_on")
  static let imgFavorisOn1 = ImageAsset(name: "img_favoris_on_1")
  static let imgFavorisOn0 = ImageAsset(name: "img_favoris_on_0")
  static let imgChevrons = ImageAsset(name: "img_chevrons")
  static let imgIcAccueilBt2 = ImageAsset(name: "img_ic_accueil_bt_2")
  static let imgNoImages = ImageAsset(name: "img_no_images")
  static let imgFavoris1 = ImageAsset(name: "img_favoris_1")
  static let imgFavoris0 = ImageAsset(name: "img_favoris_0")
  static let imgIcNetwork = ImageAsset(name: "img_ic_network")
  static let imgMenuCellPoint = ImageAsset(name: "img_menu_cell_point")
  static let imageRestoSliderCache = ImageAsset(name: "image_resto_slider_cache")
  static let imgFavorisStarOff = ImageAsset(name: "img_favoris_star_off")
  static let imgFavorisStarOffWhite = ImageAsset(name: "img_favoris_star_off_white")
  static let imgIcMore = ImageAsset(name: "img_ic_more")
  static let imgBtOrangeNext = ImageAsset(name: "img_bt_orange_next")
  static let imgSettingsMail = ImageAsset(name: "img_settings_mail")
  static let imageResto1 = ImageAsset(name: "image_resto_1")
  static let imageResto0 = ImageAsset(name: "image_resto_0")
  static let imgBtMapsOrangeOff = ImageAsset(name: "img_bt_maps_orange_off")
  static let imgFavorisWh = ImageAsset(name: "img_favoris_wh")
  static let imgMenu0 = ImageAsset(name: "img_menu_0")
  static let imgMenu1 = ImageAsset(name: "img_menu_1")
  static let imgDetailResto = ImageAsset(name: "img_detail_resto")
  static let imgBtLocalisation = ImageAsset(name: "img_bt_localisation")
  static let imgBtFbOrangeOn = ImageAsset(name: "img_bt_fb_orange_on")
  static let imgFavorisStarOn = ImageAsset(name: "img_favoris_star_on")
  static let imgBtWebOrangeOff = ImageAsset(name: "img_bt_web_orange_off")
  static let imgAnotation2 = ImageAsset(name: "img_anotation_2")
  static let imgSettingsDoc = ImageAsset(name: "img_settings_doc")
  static let imgHeader = ImageAsset(name: "img_header")
  static let takePhoto = ImageAsset(name: "take_photo")
  static let imgLogo = ImageAsset(name: "img_logo")
  static let imgFavorisOrangeOff = ImageAsset(name: "img_favoris_orange_off")
  static let commentsBubblesOutline = ImageAsset(name: "comments-bubbles-outline")
  static let imgBtReturnOrange = ImageAsset(name: "img_bt_return_orange")
  static let imgMenuBtNextWhite = ImageAsset(name: "img_menu_bt_next_white")
  static let imgVeganOff = ImageAsset(name: "img_vegan_off")
  static let imgIcPhone = ImageAsset(name: "img_ic_phone")

  // swiftlint:disable trailing_comma
  static let allColors: [ColorAsset] = [
  ]
  static let allImages: [ImageAsset] = [
    icMenuInsta,
    imgGlutenFreeOff,
    imgBtLocalisationBlack,
    imgIcAccueilBt1,
    imgFavorisOn2,
    favorites,
    imgFavoris2,
    imgGlutenFreeOn,
    addPost,
    imgIcMoreBlack,
    imgMenuFavoris,
    imgBtMailOrangeOff,
    imgIcMapsBlack,
    error,
    imgAnotationLock,
    imgBtTelOrangeOff,
    imgMenuRestos,
    imgIcMaps,
    imageRestoPlaceolder,
    imgBtShare,
    imgGlutenFreeOffWhite,
    imgFavorisOff,
    imgBtTelOrangeOn,
    imgBtOrangeShare,
    imgAnotation0,
    imgAnotation1,
    imgIcPhoneBlack,
    imgFavorisStarOnWhite,
    icMenuFacebook,
    imgBtMapsOrangeOn,
    imgMenuBg0,
    pastilleV,
    imgMenu3,
    imgMenu2,
    rightChevron,
    imgBtMenu,
    imgFavorisStarHalf,
    imgBtMailOrangeOn,
    imgVeganOn,
    imgMenuCell4,
    icMenuTwitter,
    imgVeganOffWhite,
    imgBtWebOrangeOn,
    imgBtBack,
    imgBtFbOrangeOff,
    imgSeparateurDetailResto,
    leftChevron,
    imgFavorisOn,
    imgFavorisOrangeOn,
    imgFavorisOn1,
    imgFavorisOn0,
    imgChevrons,
    imgIcAccueilBt2,
    imgNoImages,
    imgFavoris1,
    imgFavoris0,
    imgIcNetwork,
    imgMenuCellPoint,
    imageRestoSliderCache,
    imgFavorisStarOff,
    imgFavorisStarOffWhite,
    imgIcMore,
    imgBtOrangeNext,
    imgSettingsMail,
    imageResto1,
    imageResto0,
    imgBtMapsOrangeOff,
    imgFavorisWh,
    imgMenu0,
    imgMenu1,
    imgDetailResto,
    imgBtLocalisation,
    imgBtFbOrangeOn,
    imgFavorisStarOn,
    imgBtWebOrangeOff,
    imgAnotation2,
    imgSettingsDoc,
    imgHeader,
    takePhoto,
    imgLogo,
    imgFavorisOrangeOff,
    commentsBubblesOutline,
    imgBtReturnOrange,
    imgMenuBtNextWhite,
    imgVeganOff,
    imgIcPhone,
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
