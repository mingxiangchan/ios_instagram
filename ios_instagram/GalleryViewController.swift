//
//  GalleryViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var selectedImageView: UIImageView!

    @IBOutlet weak var galleryCollectionVIew: UICollectionView!
    var images = [UIImage]()
    var currentOverlayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadImagePicker()
    }

    func loadImagePicker(){
        if self.checkImageAuthorization(){
            let allPhotosOptions = PHFetchOptions()
            let imageManager = PHCachingImageManager()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let allPhotosResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: allPhotosOptions)
            
            // Now if you want you can get assets from the PHFetchResult object:
            allPhotosResult.enumerateObjectsUsingBlock({ (object: AnyObject!, count: Int,
                stop: UnsafeMutablePointer<ObjCBool>) in
                if object is PHAsset{
                    let asset = object as! PHAsset
                    let imageSize = CGSize(width: asset.pixelWidth,
                        height: asset.pixelHeight)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .FastFormat
                    options.synchronous = true
                    imageManager.requestImageForAsset(asset, targetSize: imageSize, contentMode: .AspectFill, options: options, resultHandler: { image, info in
                        self.images.append(image!)
                    })
                }
            })
            
            self.galleryCollectionVIew.reloadData()
            self.selectedImageView.image = self.images[0]
        }
    }

    func checkImageAuthorization() -> Bool{
        //check for permission to access file system assets
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .Denied, .Restricted :
            return false
        case .NotDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                self.checkImageAuthorization()
                return
            }
        }
        return false
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        let image = self.images[indexPath.row]
        let imageView = UIImageView()
        let imageWidth = (self.view.frame.size.width - 40)/4
        imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth)
        imageView.image = image
        // set cell to semi transparent if selected
        if indexPath.row == self.currentOverlayIndex {
            print(indexPath.row)
            cell.alpha = 0.5
        }
        cell.addSubview(imageView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // set size for collectionviewcell to 1/4th of page with 10 line spacing
        let imageWidth = (self.view.frame.size.width - 40)/4
        return CGSizeMake(imageWidth, imageWidth)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // set selected image view to the selected image in collectionview
        self.selectedImageView.image = self.images[indexPath.row]
        self.currentOverlayIndex = indexPath.row
        self.galleryCollectionVIew.reloadData()
    }

    @IBAction func onUploadButtonPressed(sender: UIBarButtonItem) {
        // convert image to base64 string with 50% compression
        let image = self.selectedImageView.image
        let imageData: NSData = UIImageJPEGRepresentation(image!, 0.5)!
        let imageString = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        // add image to pictures
        let ref = DataServices.dataService
        let picRef = ref.BASE_REF.childByAppendingPath("pictures").childByAutoId()
        picRef.setValue(["image_data": imageString])
        
        // add image to belong to current_user
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        let userRef = ref.USER_REF.childByAppendingPath(currentUserID)
        userRef.childByAppendingPath("pictures").updateChildValues([picRef.key:"true"])
        self.performSegueWithIdentifier("unwindToHomeSegue", sender: self)
    }
}
