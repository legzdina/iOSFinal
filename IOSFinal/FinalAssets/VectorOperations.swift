//
//  VectorOperations.swift
//  IOSFinal
//
//  Created by Kristine Legzdina on 20/04/2019.
//  Copyright © 2019 Kristine Legzdina. All rights reserved.
//

import Foundation
import SceneKit


func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x:left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}


func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}
