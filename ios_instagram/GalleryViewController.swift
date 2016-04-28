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
        self.loadTitle("GALLERY")
        self.loadBackButton()
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
        let imageWidth = (self.view.frame.size.width - 20)/4
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
        let imageWidth = (self.view.frame.size.width - 20)/4
        return CGSizeMake(imageWidth, imageWidth)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // set selected image view to the selected image in collectionview
        self.selectedImageView.image = self.images[indexPath.row]
        self.currentOverlayIndex = indexPath.row
        self.galleryCollectionVIew.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareSegue" {
            let destination = segue.destinationViewController as! ShareViewController
            destination.image = self.selectedImageView.image
        }
    }
    
    func loadTitle(string: String)->Void{
        let lbNavTitle = UILabel()
        lbNavTitle.frame = CGRectMake(-20,40,320,40)
        lbNavTitle.textAlignment = NSTextAlignment.Left
        let attributes = [NSFontAttributeName: UIFont.init(name: "HelveticaNeue-Bold" , size: 18)!]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        lbNavTitle.textColor = UIColor.whiteColor()
        lbNavTitle.attributedText = attributedString
        self.navigationItem.titleView = lbNavTitle;
        self.navigationController?.navigationBar.barTintColor = PRIMARY_BLUE_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func loadBackButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
}
