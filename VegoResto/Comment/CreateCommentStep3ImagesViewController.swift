//
//  CreateCommentStep3ImagesViewController.swift
//  VegoResto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import TLPhotoPicker

protocol  CreateCommentStep3ImagesViewControllerProtocol {

}

class CreateCommentStep3ImagesViewController: UIViewController, CreateCommentStep3ImagesViewControllerProtocol {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var imageViewLabel: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clicPhoto(_ sender: UIButton) {

        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        var configurateur = TLPhotosPickerConfigure()
        configurateur.allowedLivePhotos = false
        configurateur.allowedVideo = false
        configurateur.maxSelectedAssets = 1
        configurateur.defaultCameraRollTitle = "Mes images"
        configurateur.tapHereToChange = "ici pour changer"
        configurateur.cancelTitle = "Annuler"
        configurateur.doneTitle = "Ok"

        viewController.configure = configurateur
        //configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main) // If you want use your custom cell..

        self.present(viewController, animated: true, completion: nil)

    }

    @IBAction func clicNext(_ sender: UIButton) {

        if let parent = self.parent as? AddCommentContainerViewController {
            parent.nextAction(sender: nil)
        }

    }

}

extension CreateCommentStep3ImagesViewController : TLPhotosPickerViewControllerDelegate {

    //TLPhotosPickerViewControllerDelegate
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image

        print("dismissPhotoPicker \(withTLPHAssets)")

        if let image = withTLPHAssets.first?.fullResolutionImage {
            self.imageView?.image = image
            self.imageView?.layer.cornerRadius = 64
            self.imageView?.layer.borderWidth = 2
            self.imageView?.layer.borderColor = UIColor.white.cgColor
            self.imageView?.contentMode = .center
            self.imageViewLabel?.setTitle("Choisir une autre photo", for: UIControlState.normal)
        }
    }

    func photoPickerDidCancel() {
        // cancel
        print("did cancel")
    }
    func dismissComplete() {
        print("dismissComplete")
        // picker viewcontroller dismiss completion
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {

        print("didExceedMaximumNumberOfSelection")
    }

}
