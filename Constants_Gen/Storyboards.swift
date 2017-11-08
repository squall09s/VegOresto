// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import VegoResto

// swiftlint:disable file_length

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
  }
}

struct SceneType<T: Any> {
  let storyboard: StoryboardType.Type
  let identifier: String

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

struct InitialSceneType<T: Any> {
  let storyboard: StoryboardType.Type

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

protocol SegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    performSegue(withIdentifier: segue.rawValue, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
  enum LaunchScreen: StoryboardType {
    static let storyboardName = "LaunchScreen"

    static let initialScene = InitialSceneType<UIViewController>(storyboard: LaunchScreen.self)
  }
  enum Main: StoryboardType {
    static let storyboardName = "Main"

    static let initialScene = InitialSceneType<VegoResto.MainViewController>(storyboard: Main.self)

    static let mainViewController = SceneType<VegoResto.MainViewController>(storyboard: Main.self, identifier: "MainViewController")

    static let mapsViewController = SceneType<VegoResto.MapsViewController>(storyboard: Main.self, identifier: "MapsViewController")

    static let menuLateral = SceneType<VegoResto.MenuLateral>(storyboard: Main.self, identifier: "MenuLateral")

    static let navigationController = SceneType<UITabBarController>(storyboard: Main.self, identifier: "NavigationController")

    static let rechercheViewController = SceneType<VegoResto.RechercheViewController>(storyboard: Main.self, identifier: "RechercheViewController")
  }
}

enum StoryboardSegue {
  enum Main: String, SegueType {
    case segueToCreateCommentStep1ViewController = "SegueToCreateCommentStep1ViewController"
    case segueToCreateCommentStep2UserViewController = "SegueToCreateCommentStep2UserViewController"
    case segueToCreateCommentStep3ImagesViewController = "SegueToCreateCommentStep3ImagesViewController"
    case segueToCreateCommentStep4ResumeViewController = "SegueToCreateCommentStep4ResumeViewController"
    case segueToAddComment = "segue_to_addComment"
    case segueToComments = "segue_to_comments"
    case segueToDetail = "segue_to_detail"
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
