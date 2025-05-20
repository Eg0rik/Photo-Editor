//
//  Functions.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import UIKit
import FirebaseAuth
import CoreImage

func getAuthErrorMessage(_ error: NSError) -> String {
    guard let code = AuthErrorCode(rawValue: error.code) else {
        return error.localizedDescription
    }
    
    switch code {
        case .invalidEmail:
            return "Invalid email address."
        case .wrongPassword:
            return "Wrong password. Try again."
        case .userNotFound:
            return "No user found with this email."
        case .userDisabled:
            return "This user account has been disabled."
        case .tooManyRequests:
            return "Too many login attempts. Try again later."
        case .networkError:
            return "Network error. Check your internet connection."
        default:
            return error.localizedDescription
    }
}

func fittedRect(for imageSize: CGSize, in containerSize: CGSize) -> CGRect {
    let imageAspect = imageSize.width / imageSize.height
    let containerAspect = containerSize.width / containerSize.height
    
    var resultSize = CGSize.zero
    
    if imageAspect > containerAspect {
        // Image is wider
        resultSize.width = containerSize.width
        resultSize.height = containerSize.width / imageAspect
    } else {
        // Image is taller
        resultSize.height = containerSize.height
        resultSize.width = containerSize.height * imageAspect
    }
    
    let origin = CGPoint(
        x: (containerSize.width - resultSize.width) / 2,
        y: (containerSize.height - resultSize.height) / 2
    )
    
    return CGRect(origin: origin, size: resultSize)
}

func createNewImageWithFilter(_ image: UIImage, filter : FilterType) -> UIImage {
    guard filter != .original else { return image }
    
    let filter = CIFilter(name: filter.rawValue)
    
    let ciInput = CIImage(image: image)
    
    filter?.setValue(ciInput, forKey: "inputImage")
    
    let ciOutput = filter?.outputImage
    let ciContext = CIContext()
    let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
    
    return UIImage(cgImage: cgImage!)
}
