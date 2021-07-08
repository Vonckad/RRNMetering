//
//  Model.swift
//  RRNMetering
//
//  Created by Vlad Ralovich on 1.07.21.
//

import Foundation

struct Model {
    var name: String
    var ip: String
}

var model: [Model] = []

func crealeModel() {
    model.append(.init(name: "RRN_29_0007_3", ip: "10.18.215.1"))
    model.append(.init(name: "RRN_29_0084_1", ip: "10.18.215.2"))
    model.append(.init(name: "RRN_29_0001_13", ip: "10.18.215.3"))
    model.append(.init(name: "RRN_29_0801_1", ip: "10.18.215.4"))
    model.append(.init(name: "RRN_29_0104_4", ip: "10.18.215.8"))
    model.append(.init(name: "RRN_29_0200_4", ip: "10.18.215.9"))
    model.append(.init(name: "RRN_29_0002_4", ip: "10.18.215.10"))
    model.append(.init(name: "RRN_29_0105_2", ip: "10.18.215.11"))
    model.append(.init(name: "RRN_29_0014_4", ip: "10.18.215.12"))
    model.append(.init(name: "RRN_29_0029_4_EXT2", ip: "10.18.215.13"))
    model.append(.init(name: "RRN_29_0105_1", ip: "10.18.215.14"))
    model.append(.init(name: "RRN_29_0116_1", ip: "10.18.215.15"))
    model.append(.init(name: "RRN_29_0112_3", ip: "10.18.215.16"))
    model.append(.init(name: "RRN_29_0073_1", ip: "10.18.215.17"))
    model.append(.init(name: "RRN_29_0205_1", ip: "10.18.215.18"))
    model.append(.init(name: "RRN_29_0015_2", ip: "10.18.215.19"))
    model.append(.init(name: "RRN_29_0200_2", ip: "10.18.215.20"))
    model.append(.init(name: "RRN_29_0019_2", ip: "10.18.215.21"))
    model.append(.init(name: "RRN_29_0105_EXT6", ip: "10.18.215.22"))
    model.append(.init(name: "RRN_29_0077_3", ip: "10.18.215.23"))
    model.append(.init(name: "RRN_29_0204_4", ip: "10.18.215.24"))
    model.append(.init(name: "RRN_29_0209_1", ip: "10.18.215.25"))
    model.append(.init(name: "RRN_29_0105_3", ip: "10.18.215.26"))
    model.append(.init(name: "RRN_29_0014_2", ip: "10.18.215.27"))
    model.append(.init(name: "RRN_29_0204_2", ip: "10.18.215.28"))
    model.append(.init(name: "RRN_29_0806_1", ip: "10.18.215.29"))
}
