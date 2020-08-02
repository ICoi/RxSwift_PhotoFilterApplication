//
//  PhotosSelectViewController.swift
//  DaunPractice_PhotoFilterApp
//
//  Created by 정다운 on 2020/08/02.
//  Copyright © 2020 daunjoung. All rights reserved.
//

import UIKit
import Photos
import RxSwift

class PhotosSelectViewController: UIViewController {

	var images : [PHAsset]? = [PHAsset]()
	@IBOutlet var imageCollectionView: UICollectionView!
	@IBOutlet var errorImage: UIImageView!
	
	public let selectedImage : PublishSubject = PublishSubject<UIImage>()
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		requestPhotos()
	}

	func requestPhotos() {
		PHPhotoLibrary.requestAuthorization { (status) in
			if status == .authorized {
				// Get Photos
				let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
				
				assets.enumerateObjects { (object, count, stop) in
				   self.images?.append(object)
			   }
							   
				self.images?.reverse()
				
                DispatchQueue.main.async {
					self.imageCollectionView.reloadData()
				}
				
			} else {
				// TODO: Error Handling
                DispatchQueue.main.async {
					self.imageCollectionView.isHidden = true
					self.errorImage.isHidden = false
				}
			}
		}
	}

}

extension PhotosSelectViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHOTO_IMAGE_CELL", for: indexPath) as? PhotosSelectCollectionViewCell else {
			fatalError("Cell Not found Error")
		}
		  
		guard let asset = self.images?[indexPath.row] else {
			fatalError("Index is overflowed")
		}
	  let manager = PHImageManager.default()
	  
	  manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, _ in
		  
		  DispatchQueue.main.async {
			 cell.imageView.image = image
		  }
		  
	  }
		
		return cell
	}
	
	
}


extension PhotosSelectViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		guard let selectAsset = self.images?[indexPath.row] else {
			fatalError("Error")
		}
		PHImageManager.default().requestImage(for: selectAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool

            if !isDegradedImage {
                
                if let image = image {
					self?.selectedImage.onNext(image)
					self?.navigationController?.popViewController(animated: true)
                }
                
            }
            
        }
		
	}
}
