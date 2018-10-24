//
//  Response.swift
//  NanoChallengeNASA
//
//  Created by Mateus Rodrigues on 18/10/18.
//  Copyright © 2018 Mateus Rodrigues. All rights reserved.
//

import Foundation
import UIKit

struct Response: Decodable {
    var version: String
    var items = [Image]()
    
    enum CodingKeys: String, CodingKey {
        case collection
    }
    
    enum CollectionKeys: String, CodingKey {
        case items, version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let collection = try container.nestedContainer(keyedBy: CollectionKeys.self, forKey: .collection)
        self.version = try collection.decode(String.self, forKey: .version)
        self.items = try collection.decode([Image].self, forKey: .items)
    }
}

struct Image: Decodable {
    
    var href: String?
    var id: String?
    var title: String?
    var description: String?
    var thumbUrl: URL?
    var imageSize: CGSize?
    
    enum CodingKeys: String, CodingKey {
        case links, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let data = try container.decode([ImageData].self, forKey: .data)
        let links = try container.decode([ImageLink].self, forKey: .links)
        
        self.id = data.first?.nasa_id
        self.title = data.first?.title
        self.description = data.first?.description
        self.thumbUrl = URL(string: (links.first?.href.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!)
    }
    
    mutating func setSize(width: Int?, height: Int?) {
        guard let width = width, let height = height else {
            self.imageSize = nil
            return
        }
        self.imageSize = CGSize(width: width, height: height)
    }
    
}

struct ImageData: Decodable {
    var description: String
    var title: String
    var nasa_id: String
}

struct ImageLink: Decodable {
    var href: String
}

struct Metadata: Decodable {
    
    var fileImageHeight: Int?
    var fileImageWidth: Int?
    var exifImageHeight: Int?
    var exifImageWidth: Int?
    
    enum CodingKeys: String, CodingKey {
        case fileImageHeight = "File:ImageHeight"
        case fileImageWidth = "File:ImageWidth"
        case exifImageHeight = "EXIF:ImageHeight"
        case exifImageWidth = "EXIF:ImageWidth"
    }
    
}

struct PictureOfTheDay: Decodable {
    let date: String?
    let explanation: String?
    let title: String?
    let url: String?
}
