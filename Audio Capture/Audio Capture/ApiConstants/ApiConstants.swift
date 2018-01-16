//
//  ApiConstants.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 08/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation

enum ApiConstant: String {
    case root = "http://ec2-35-177-218-234.eu-west-2.compute.amazonaws.com"
    case login = "api/login"
    case favourite = "api/get-favourite"
    case inbox = "api/get-inbox"
    case sync = "io.github.halo.linkdaemon"
    case uploadAudio = "io.github.halo.linkdaemon1"

    static func pathFor(type:ApiConstant) -> String {
        return "\(ApiConstant.root.rawValue)/\(type.rawValue)"
    }
}

