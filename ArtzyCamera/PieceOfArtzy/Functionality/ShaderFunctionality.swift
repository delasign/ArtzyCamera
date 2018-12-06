//
//  ShaderFunctionality.swift
//  ArtzyCamera
//
//  Created by Oscar De la Hera Gomez on 12/3/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

import Foundation
import ARKit

extension PieceOfArtzy {
    
    // MARK: SHADERS
    
    func addColorShaderForChild(child: SCNNode, red:Float, blue:Float, green:Float) {
        let program = SCNProgram()
        var programType:String = "Color"
        program.fragmentFunctionName = programType+"SurfaceFragment"
        program.vertexFunctionName = programType+"VertexShader"
        program.isOpaque = false;
        
        // CREATE A MATERIAL, ADD THE PROGRAM, AND ADD IT TO THE CHILD.
        let shaderMaterial = SCNMaterial()
        shaderMaterial.program = program;
        shaderMaterial.transparencyMode = .rgbZero;
        shaderMaterial.isDoubleSided = true;
        shaderMaterial.blendMode = .alpha;
        shaderMaterial.writesToDepthBuffer = false
        shaderMaterial.readsFromDepthBuffer = false
        shaderMaterial.cullMode = .back
        shaderMaterial.lightingModel = .lambert;
        
        var TimeVariables:timedShaderVariablesStruct = timedShaderVariablesStruct.init(loopTime: 10, startTime: 0, endTime: 0, colorR:red, colorB:blue, colorG:green);
        shaderMaterial.setValue(Data(bytes: &TimeVariables, count: MemoryLayout<timedShaderVariablesStruct>.stride), forKey: "timeVariables");
        
        child.geometry?.materials = [shaderMaterial];
    }
    
    func addTextureShaderForChild(child: SCNNode, texture:UIImage) {
        let program = SCNProgram()
        var programType:String = "Texture"
        program.fragmentFunctionName = programType+"SurfaceFragment"
        program.vertexFunctionName = programType+"VertexShader"
        program.isOpaque = false;
        
        // CREATE A MATERIAL, ADD THE PROGRAM, AND ADD IT TO THE CHILD.
        let shaderMaterial = SCNMaterial()
        shaderMaterial.program = program;
        shaderMaterial.transparencyMode = .rgbZero;
        shaderMaterial.isDoubleSided = false;
        shaderMaterial.blendMode = .alpha;
        shaderMaterial.writesToDepthBuffer = true
        shaderMaterial.readsFromDepthBuffer = true
        shaderMaterial.cullMode = .back
        shaderMaterial.lightingModel = .lambert;
        
        let imageProperty = SCNMaterialProperty(contents: texture)
        shaderMaterial.setValue(imageProperty, forKey: "diffuseTexture")
        
        //        var TimeVariables:timedShaderVariablesStruct = timedShaderVariablesStruct.init(loopTime: 10, startTime: 0, endTime: 0, colorR:red, colorB:blue, colorG:green);
        //        shaderMaterial.setValue(Data(bytes: &TimeVariables, count: MemoryLayout<timedShaderVariablesStruct>.stride), forKey: "timeVariables");
        
        child.geometry?.materials = [shaderMaterial];
    }
    
    func addTimedStrokeShaderWithTimeForChild(child:SCNNode, loopTime:Float, startTime:Float, endTime:Float) {
        
        
        DispatchQueue.main.async {
            let program = SCNProgram()
            let programType:String = "TimedStroke"
            
            
            program.fragmentFunctionName = programType+"SurfaceFragment"
            program.vertexFunctionName = programType+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = false
            shaderMaterial.readsFromDepthBuffer = false
            shaderMaterial.cullMode = .back
            
            var firstStrokeTimeVariableStruct:strokeTimeVariableStruct = strokeTimeVariableStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime);
            shaderMaterial.setValue(Data(bytes: &firstStrokeTimeVariableStruct, count: MemoryLayout<strokeTimeVariableStruct>.stride), forKey: "timeVariables");
            
            child.geometry?.materials = [shaderMaterial];
        }
    }
    
    func addBackwardsTimedStrokeShaderWithTimeForChild(child:SCNNode, loopTime:Float, startTime:Float, endTime:Float) {
        
        
        DispatchQueue.main.async {
            let program = SCNProgram()
            let programType:String = "BackwardsTimedStroke"
            
            
            program.fragmentFunctionName = programType+"SurfaceFragment"
            program.vertexFunctionName = programType+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = false
            shaderMaterial.readsFromDepthBuffer = false
            shaderMaterial.cullMode = .back
            
            var firstStrokeTimeVariableStruct:strokeTimeVariableStruct = strokeTimeVariableStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime);
            shaderMaterial.setValue(Data(bytes: &firstStrokeTimeVariableStruct, count: MemoryLayout<strokeTimeVariableStruct>.stride), forKey: "timeVariables");
            
            child.geometry?.materials = [shaderMaterial];
        }
    }
    
    func addTimedStrokeTextureShaderWithTimeForChild(child:SCNNode, loopTime:Float, startTime:Float, endTime:Float) {
        
        
        DispatchQueue.main.async {
            let program = SCNProgram()
            let programType:String = "TimedStrokeTexture"
            
            
            program.fragmentFunctionName = programType+"SurfaceFragment"
            program.vertexFunctionName = programType+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = false
            shaderMaterial.readsFromDepthBuffer = false
            shaderMaterial.cullMode = .back
            
            var firstStrokeTimeVariableStruct:strokeTimeVariableStruct = strokeTimeVariableStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime);
            shaderMaterial.setValue(Data(bytes: &firstStrokeTimeVariableStruct, count: MemoryLayout<strokeTimeVariableStruct>.stride), forKey: "timeVariables");
            
            child.geometry?.materials = [shaderMaterial];
        }
    }
    
    func addBackwardsTimedStrokeTextureShaderWithTimeForChild(child:SCNNode, texture:UIImage, loopTime:Float, startTime:Float, endTime:Float) {
        
        
        DispatchQueue.main.async {
            let program = SCNProgram()
            let programType:String = "BackwardsTimedStrokeTexture"
            
            
            program.fragmentFunctionName = programType+"SurfaceFragment"
            program.vertexFunctionName = programType+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = true
            shaderMaterial.readsFromDepthBuffer = true
            shaderMaterial.cullMode = .back
            //            shaderMaterial.diffuse.contents? = texture;
            shaderMaterial.lightingModel = .lambert;
            
            let imageProperty = SCNMaterialProperty(contents: texture)
            // The name you supply here should match the texture parameter name in the fragment shader
            shaderMaterial.setValue(imageProperty, forKey: "diffuseTexture")
            
            var firstStrokeTimeVariableStruct:strokeTimeVariableStruct = strokeTimeVariableStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime);
            shaderMaterial.setValue(Data(bytes: &firstStrokeTimeVariableStruct, count: MemoryLayout<strokeTimeVariableStruct>.stride), forKey: "timeVariables");
            
            child.geometry?.materials = [shaderMaterial];
        }
    }
    
    func getShaderMaterialWithTitle(title:String) -> SCNMaterial {
        
        let program = SCNProgram()
        
        program.fragmentFunctionName = title+"SurfaceFragment"
        program.vertexFunctionName = title+"VertexShader"
        
        program.isOpaque = false;
        
        let shaderMaterial = SCNMaterial();
        shaderMaterial.program = program;
        shaderMaterial.transparencyMode = .rgbZero;
        shaderMaterial.blendMode = .alpha;
        shaderMaterial.writesToDepthBuffer = false
        shaderMaterial.readsFromDepthBuffer = false
        shaderMaterial.cullMode = .back
        
        return shaderMaterial
    }
    
    func addTimedVariablesToShaderWithNameAndChild(programName:String, child:SCNNode, loopTime:Float, startTime:Float, endTime:Float, colorR:Float, colorB:Float, colorG:Float) {
        
        
        DispatchQueue.main.async {
            let program = SCNProgram();
            
            
            program.fragmentFunctionName = programName+"SurfaceFragment"
            program.vertexFunctionName = programName+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = true
            shaderMaterial.readsFromDepthBuffer = true
            shaderMaterial.cullMode = .back
            
            var timedShaderVariables:timedShaderVariablesStruct = timedShaderVariablesStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime, colorR: colorR, colorB: colorB, colorG: colorG)
            shaderMaterial.setValue(Data(bytes: &timedShaderVariables, count: MemoryLayout<timedShaderVariablesStruct>.stride), forKey: "timedShaderVariables");
            
            child.geometry?.materials = [shaderMaterial];
        }
    }
    
    
    func addStrokeShaderWithTimeForChild(child:SCNNode, loopTime:Float, startTime:Float, endTime:Float) {
        
        
            let program = SCNProgram()
            var programType:String = "TimedStroke"
            
            
            program.fragmentFunctionName = programType+"SurfaceFragment"
            program.vertexFunctionName = programType+"VertexShader"
            
            program.isOpaque = false;
            
            let shaderMaterial = SCNMaterial();
            shaderMaterial.program = program;
            shaderMaterial.transparencyMode = .rgbZero;
            shaderMaterial.blendMode = .alpha;
            shaderMaterial.writesToDepthBuffer = false
            shaderMaterial.readsFromDepthBuffer = false
            shaderMaterial.cullMode = .back
            
            var firstStrokeTimeVariableStruct:strokeTimeVariableStruct = strokeTimeVariableStruct.init(loopTime: loopTime, startTime: startTime, endTime: endTime);
            //strokeTimeVariableStruct(loopTime: loopTime, startTime: startTime, endTime: endTime);
            shaderMaterial.setValue(Data(bytes: &firstStrokeTimeVariableStruct, count: MemoryLayout<strokeTimeVariableStruct>.stride), forKey: "timeVariables");
            
            child.geometry?.materials = [shaderMaterial];
    }
    
}

