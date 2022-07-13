//
//  Downloader+URLSessionDelegate.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 1/6/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import os.log

let supportFormat = ["audio/mpeg", "audio/aacp", "application/octet-stream"]

enum MimeTypeError:Error {
    case unsupportedFormat
}

extension Downloader: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line)

        totalBytesCount = response.expectedContentLength
//        print("totalBytesCount:\(totalBytesCount)")
        let mimeType = response.mimeType
        print("mineType:\(String(describing: mimeType))")
        if let mimeType = mimeType, !supportFormat.contains(mimeType) {
            let error = MimeTypeError.unsupportedFormat
            delegate?.download(self, completedWithError: error)
            completionHandler(.cancel)
        } else {
            completionHandler(.allow)
        }
        
        
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line, data.count)
        let response = dataTask.response
//        print("\(String(describing: response?.mimeType))")
        guard let mimeType = response?.mimeType else {return}
        if supportFormat.contains(mimeType){
            totalBytesReceived += Int64(data.count)
            progress = Float(totalBytesReceived) / Float(totalBytesCount)
//            print("totalBytesReceived:\(totalBytesReceived)")
            delegate?.download(self, didReceiveData: data, progress: progress)
            progressHandler?(data, progress)
        } else  {
            print("other response:\(String(describing: response))")
        }
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        os_log("%@ - %d", log: Downloader.logger, type: .debug, #function, #line)
        var networkError = error
        let statusCode = (task.response as? HTTPURLResponse)?.statusCode
        if networkError == nil && statusCode != 200 {
             networkError = NSError(domain:"", code: statusCode!, userInfo: nil)
        }
        state = .completed
        delegate?.download(self, completedWithError: error)
        completionHandler?(error)
    }
}
