//
//  ViewController.swift
//  DaunPractice_PhotoFilterApp
//
//  Created by 정다운 on 2020/08/02.
//  Copyright © 2020 daunjoung. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
	
	@IBOutlet var filterImgView: UIImageView!
	
	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	// MARK: OnButton Listener
	@IBAction func applyFilter(_ sender: Any) {
		let filterService = FilterService()
		guard let filterImag = filterImgView.image else {
			 return
		}
		filterService.applyFilter(to: filterImag) { (image) in
			self.filterImgView.image = image
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		 guard let navC = segue.destination as? PhotosSelectViewController else {
			return
		}
		
		navC.selectedImage.subscribe(onNext: { (image) in
			self.filterImgView.image = image
		}, onError: { (error) in
			// todo
		}, onCompleted: {
			// todo
		}, onDisposed: {
			// todo disposed
		}).disposed(by: disposeBag)
		
		
		
	}


}

