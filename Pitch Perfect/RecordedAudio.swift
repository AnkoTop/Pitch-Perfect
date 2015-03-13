//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Anko Top on 10/03/15.
//      Added contructor on 12/03/15.
//
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        
        self.filePathUrl = filePathUrl
        self.title  = title        
    }
}