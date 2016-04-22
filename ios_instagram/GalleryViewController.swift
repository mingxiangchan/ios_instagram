//
//  GalleryViewController.swift
//  ios_instagram
//
//  Created by Ming Xiang Chan on 22/04/2016.
//  Copyright © 2016 NEXTACADEMY. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var selectedImageView: UIImageView!

    @IBOutlet weak var galleryCollectionVIew: UICollectionView!
    var imageAssets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadImagePicker()
    }

    func loadImagePicker(){
        if self.checkImageAuthorization(){
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let allPhotosResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: allPhotosOptions)
            
            // Now if you want you can get assets from the PHFetchResult object:
            allPhotosResult.enumerateObjectsUsingBlock({ print("Asset \($0.0)")})
        }
    }

    func checkImageAuthorization() -> Bool{
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
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        return cell
    }

}
