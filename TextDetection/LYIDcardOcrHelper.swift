//
//  LYIDcardOcrHelper.swift
//  TextDetection
//
//  Created by edz on 2020/11/2.
//

import Foundation
import Vision
import UIKit

///识别协议
protocol LYIDCardOcrPortocol {
    /**
      @brief 识别成功
      @param 识别的身份证号码
    **/
    func didDtectedIDNumber(idNum:String)
    /**
      @brief 识别失败
      @param 识别的错误
    **/
    func didFailedDetectNumber(error:Error)
}

///构建错误类
enum LYOCRError : Error {
    case exceptionErro(msg:String)
}

class LYIDCardOcrHeler: NSObject {
    
   static let `default` = LYIDCardOcrHeler()
    
   var delegate : LYIDCardOcrPortocol?
    
   /**
     @brief 传入图片进行识别
     @param 选取的UIImage
   **/
    
    func starRecognition(_ img:UIImage) throws
    {
        guard self.delegate != nil else {
            throw LYOCRError.exceptionErro(msg: "需要初始化代理对象")
        }
        
        if let cgImg = img.cgImage
        {
            
            configRequest(cgImg)
        }else{
            delegate!.didFailedDetectNumber(error: LYOCRError.exceptionErro(msg: "图片无效"))
        }
    }
    
    /**
      @brief 配置Core ML文字识别
      @param 需要识别的image
    **/
     
    private func configRequest(_ cgImg:CGImage)
    {
        
        //创建图片识别请求handler
        let requestHandler = VNImageRequestHandler(cgImage: cgImg, options: [:])
        do{
            //handler传入文字识别请求，类似于runloop，会识别所有文字
            try requestHandler.perform([vnTextDetectionRequest])
            
        }catch let error
        {
            delegate!.didFailedDetectNumber(error: error)
        }
    }
    
    
    
    /**
      @discusstio 创建一个文字识别请求，该请求会识别所有的文字，这时候筛选含有"公民身份号码"字段的文字，进行转义
    **/
    private var vnTextDetectionRequest : VNRecognizeTextRequest
    {
        let request = VNRecognizeTextRequest { [self] (req, error) in
            guard error == nil else {return}
            
            guard let observations = req.results as? [VNRecognizedTextObservation]
            else {
                print(error!.localizedDescription)
                return
            }
            var ocrText = ""
            
            for observation in observations
            {
                if let candidate = observation.topCandidates(1).first
                {
                    if candidate.string.contains("身份号码")
                    {
                        let code = candidate.string.components(separatedBy: "码")[1]
                        ocrText.append(code)
                    }
                }
            }
            
            delegate!.didDtectedIDNumber(idNum: ocrText)
        }
        
        request.recognitionLanguages = ["zh-CN"]
        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        return request
    }
}
