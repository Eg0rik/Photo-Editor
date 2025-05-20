//
//  Filter.swift
//  Editing Photo
//
//  Created by mac on 20.05.25.
//

import CoreImage

enum FilterType : String, CaseIterable {
    case original = "Original"
    case instant = "CIPhotoEffectInstant"
    case mono = "CIPhotoEffectMono"
    case transfer =  "CIPhotoEffectTransfer"
    
    var nameForUser: String {
        switch self {
            case .original: "Orig"
            case .instant: "Instant"
            case .mono: "Mono"
            case .transfer: "Transfer"
        }
    }
}
