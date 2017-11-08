//
//  CreateCommentStep3ImagesViewController.swift
//  VegOresto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import ImagePicker
import Photos
import MBProgressHUD

protocol  CreateCommentStep3ImagesViewControllerProtocol {

    func getImage() -> UIImage?

}

class CreateCommentStep3ImagesViewController: UIViewController, CreateCommentStep3ImagesViewControllerProtocol {

    var currentImage: UIImage?

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

        var configuration = Configuration()
        configuration.doneButtonTitle = "OK"
        configuration.noImagesTitle = "Aucune image disponible"
        configuration.recordLocation = false
        configuration.allowVideoSelection = false
        configuration.allowMultiplePhotoSelection = false

        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1

        present(imagePickerController, animated: true, completion: nil)

    }

    @IBAction func clicNext(_ sender: UIButton) {

        if let parent = self.parent as? AddCommentContainerViewController {
            parent.nextAction(sender: nil)
        }

    }

    func getImage() -> UIImage? {

       return self.currentImage

    }

}

extension CreateCommentStep3ImagesViewController : ImagePickerDelegate {

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {

        if let image = images.first {

            self.setImage(image:  image )

            imagePicker.dismiss(animated: true, completion: {

            })

        } else {

            let size = CGSize(width: 720, height: 1280)

            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.isNetworkAccessAllowed = true

            MBProgressHUD.showAdded(to: imagePicker.view, animated: true)

            imageManager.requestImage(for: imagePicker.stack.assets.first!, targetSize: size, contentMode: .aspectFit, options: requestOptions) { image, _ in

                print("imageManager.requestImage done")

                MBProgressHUD.hide(for: imagePicker.view, animated: true)

                if let image = image {

                    self.setImage(image:  image )

                    imagePicker.dismiss(animated: true, completion: {

                    })

                }

            }

        }
    }

    func setImage(image: UIImage) {

            self.imageView?.image = image
            self.imageView?.layer.cornerRadius = 64
            self.imageView?.layer.borderWidth = 2
            self.imageView?.layer.borderColor = UIColor.white.cgColor
            self.imageView?.contentMode = .scaleAspectFill
            self.imageViewLabel?.setTitle("Choisir une autre photo", for: UIControlState.normal)

            self.currentImage = image

    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {

        imagePicker.dismiss(animated: true, completion: {
        })
    }

}
