// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length

protocol StoryboardSceneType {
  static var storyboardName: String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialViewController() -> UIViewController {
    guard let vc = storyboard().instantiateInitialViewController() else {
      fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
    }
    return vc
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    static func initialViewController() -> MainViewController {
      guard let vc = storyboard().instantiateInitialViewController() as? MainViewController else {
        fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
      }
      return vc
    }

    case addCommentPopUpScene = "AddCommentPopUp"
    static func instantiateAddCommentPopUp() -> AddCommentPopUp {
      guard let vc = StoryboardScene.Main.addCommentPopUpScene.viewController() as? AddCommentPopUp
      else {
        fatalError("ViewController 'AddCommentPopUp' is not of the expected class AddCommentPopUp.")
      }
      return vc
    }

    case mainViewControllerScene = "MainViewController"
    static func instantiateMainViewController() -> MainViewController {
      guard let vc = StoryboardScene.Main.mainViewControllerScene.viewController() as? MainViewController
      else {
        fatalError("ViewController 'MainViewController' is not of the expected class MainViewController.")
      }
      return vc
    }

    case mapsViewControllerScene = "MapsViewController"
    static func instantiateMapsViewController() -> MapsViewController {
      guard let vc = StoryboardScene.Main.mapsViewControllerScene.viewController() as? MapsViewController
      else {
        fatalError("ViewController 'MapsViewController' is not of the expected class MapsViewController.")
      }
      return vc
    }

    case menuLateralScene = "MenuLateral"
    static func instantiateMenuLateral() -> MenuLateral {
      guard let vc = StoryboardScene.Main.menuLateralScene.viewController() as? MenuLateral
      else {
        fatalError("ViewController 'MenuLateral' is not of the expected class MenuLateral.")
      }
      return vc
    }

    case navigationControllerScene = "NavigationController"
    static func instantiateNavigationController() -> UITabBarController {
      guard let vc = StoryboardScene.Main.navigationControllerScene.viewController() as? UITabBarController
      else {
        fatalError("ViewController 'NavigationController' is not of the expected class UITabBarController.")
      }
      return vc
    }

    case rechercheViewControllerScene = "RechercheViewController"
    static func instantiateRechercheViewController() -> RechercheViewController {
      guard let vc = StoryboardScene.Main.rechercheViewControllerScene.viewController() as? RechercheViewController
      else {
        fatalError("ViewController 'RechercheViewController' is not of the expected class RechercheViewController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
  enum Main: String, StoryboardSegueType {
    case segueToComments = "segue_to_comments"
    case segueToDetail = "segue_to_detail"
  }
}
