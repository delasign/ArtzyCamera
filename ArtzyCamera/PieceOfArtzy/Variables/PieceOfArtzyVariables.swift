//
//  PieceOfArtzyVariables.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation

struct DisplayVariableStruct {
    var show:Float = 10;
    
    init(show:Float) {
        self.show = show;
    }
}



struct strokeTimeVariableStruct {
    var loopTime:Float = 10;
    var startTime:Float = 0;
    var endTime:Float = 5;
    
    init(loopTime:Float, startTime:Float, endTime:Float) {
        self.loopTime = loopTime;
        self.startTime = startTime;
        self.endTime = endTime;
    }
}

struct timedShaderVariablesStruct {
    var loopTime:Float = 0;
    var startTime:Float = 0;
    var endTime:Float = 0;
    var colorR:Float = 0;
    var colorB:Float = 0;
    var colorG:Float = 0;
    
    init(loopTime:Float, startTime:Float, endTime:Float, colorR:Float, colorB:Float, colorG:Float) {
        self.loopTime = loopTime;
        self.startTime = startTime;
        self.endTime = endTime;
        self.colorR = colorR;
        self.colorB = colorB;
        self.colorG = colorG;
    }
};

struct blurVariableStruct {
    var distanceToNode:Float = 10;
    
    init(distanceToNode:Float) {
        self.distanceToNode = distanceToNode;
    }
}
