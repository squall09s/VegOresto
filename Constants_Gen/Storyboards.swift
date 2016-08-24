// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

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
    return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case MainViewControllerScene = "MainViewController"
    static func instantiateMainViewController() -> MainViewController {
      guard let vc = StoryboardScene.Main.MainViewControllerScene.viewController() as? MainViewController
      else {
        fatalError("ViewController 'MainViewController' is not of the expected class MainViewController.")
      }
      return vc
    }

    case MapsViewControllerScene = "MapsViewController"
    static func instantiateMapsViewController() -> MapsViewController {
      guard let vc = StoryboardScene.Main.MapsViewControllerScene.viewController() as? MapsViewController
      else {
        fatalError("ViewController 'MapsViewController' is not of the expected class MapsViewController.")
      }
      return vc
    }

    case MenuLateralScene = "MenuLateral"
    static func instantiateMenuLateral() -> MenuLateral {
      guard let vc = StoryboardScene.Main.MenuLateralScene.viewController() as? MenuLateral
      else {
        fatalError("ViewController 'MenuLateral' is not of the expected class MenuLateral.")
      }
      return vc
    }

    case NavigationControllerScene = "NavigationController"
    static func instantiateNavigationController() -> UITabBarController {
      guard let vc = StoryboardScene.Main.NavigationControllerScene.viewController() as? UITabBarController
      else {
        fatalError("ViewController 'NavigationController' is not of the expected class UITabBarController.")
      }
      return vc
    }

    case RechercheViewControllerScene = "RechercheViewController"
    static func instantiateRechercheViewController() -> RechercheViewController {
      guard let vc = StoryboardScene.Main.RechercheViewControllerScene.viewController() as? RechercheViewController
      else {
        fatalError("ViewController 'RechercheViewController' is not of the expected class RechercheViewController.")
      }
      return vc
    }
  }
}

struct StoryboardSegue {
  enum Main: String, StoryboardSegueType {
    case Segue_to_detail = "segue_to_detail"
  }
}
