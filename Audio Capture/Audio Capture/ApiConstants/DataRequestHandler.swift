//
//  DataRequestHandler.swift
//  Audio Capture
//
//  Created by Satendra Dagar on 09/01/18.
//  Copyright © 2018 CB. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {
    public func responseJSONHandler(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }

}
