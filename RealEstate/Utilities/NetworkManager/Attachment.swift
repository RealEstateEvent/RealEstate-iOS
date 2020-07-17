//
//  Attachment.swift
//  Sail
//
//  Created by Amit Kumar on 20/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

public struct Attachment {
    private (set) var fileName : String?
    private (set) var file : Data?
    private (set) var fileParam : String?
    private (set) var mime : String?
    private (set) var extennsion: String?
    
    public enum AttachmentType {
        case audio(URL)
        case video(URL)
        case document(URL)
        case image(UIImage)
    }
    
    init(_ fileName:String? , _ fileParam:String,_ myAttachmentType: AttachmentType) {
        switch myAttachmentType {
        case .audio(let url),.video(let url),.document(let url):
            self.extennsion = url.pathExtension
            self.fileName = "\(String.getString(self.getCurrentTimeStamp()))_\(fileName ?? "").\(self.extennsion ?? "")"
            self.mime = self.extennsion?.mimeTypeFromExtension()
            do {
                let data = try Data.init(contentsOf: url)
                self.file = data
            } catch let err {
                print("Unable to convert AttachmentURl to data :\(err.localizedDescription)")
            }
            
        case .image(let image):
            if let data = image.jpegData(compressionQuality: 0.7) {
                self.file = data
                let imageType = self.file?.imageFormat.rawValue
                self.extennsion = imageType?.lowercased()
                self.mime = self.extennsion?.mimeTypeFromExtension()
            }
            self.fileName = "\(String.getString(self.getCurrentTimeStamp()))_\(fileName ?? "").\(self.extennsion ?? "")"
        }
        self.fileParam = fileParam
        
    }
    
    private func getCurrentTimeStamp()->TimeInterval {
        return NSDate().timeIntervalSince1970.rounded();
    }
}



struct ImageHeaderData {
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}
enum ImageFormat : String {
    case Unknown = "Unknown"
    case PNG = "PNG"
    case JPEG = "JPEG"
    case GIF = "GIF"
    case TIFF = "TIFF"
}
extension Data {
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &buffer, from: 0..<1)
        if buffer == ImageHeaderData.PNG { return .PNG }
        if buffer == ImageHeaderData.JPEG { return .JPEG }
        if buffer == ImageHeaderData.GIF { return .GIF }
        if buffer == ImageHeaderData.TIFF_01 ||
            buffer == ImageHeaderData.TIFF_02 {
            return .TIFF
        }
        return .Unknown
    }
}

