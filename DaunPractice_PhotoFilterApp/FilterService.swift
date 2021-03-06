//
//  FilterService.swift
//  DaunPractice_PhotoFilterApp
//
//  Created by 정다운 on 2020/08/02.
//  Copyright © 2020 daunjoung. All rights reserved.
//

import UIKit

class FilterService {

	private var context: CIContext

	init() {
		self.context = CIContext()
	}

	func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
		
		let filter = CIFilter(name: "CICMYKHalftone")!
		filter.setValue(5.0, forKey: kCIInputWidthKey)
		
		if let sourceImage = CIImage(image: inputImage) {
			
			filter.setValue(sourceImage, forKey: kCIInputImageKey)
			
			if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
				
				let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
				completion(processedImage)
				
			}
			
		}
		
	}
}
