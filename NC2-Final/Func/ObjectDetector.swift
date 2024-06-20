//
//  ObjectDetector.swift
//  NC2-Final
//
//  Created by 김하준 on 6/17/24.
//
import SwiftUI
import CoreML
import Vision

class ObjectDetector {
    var detectionModel: VNCoreMLModel
    var classificationModel: VNCoreMLModel
    
    init() {
        // 객체 인식 모델 로드
        guard let detectionModelURL = Bundle.main.url(forResource: "ObjectDetector1", withExtension: "mlmodelc"),
              let detectionModel = try? VNCoreMLModel(for: MLModel(contentsOf: detectionModelURL)) else {
            fatalError("객체 인식 모델을 로드할 수 없습니다.")
        }
        self.detectionModel = detectionModel
        
        // 분류 모델 로드
        guard let classificationModelURL = Bundle.main.url(forResource: "ClassificationModel", withExtension: "mlmodelc"),
              let classificationModel = try? VNCoreMLModel(for: MLModel(contentsOf: classificationModelURL)) else {
            fatalError("분류 모델을 로드할 수 없습니다.")
        }
        self.classificationModel = classificationModel
    }
    
    func detectObjects(in image: UIImage, completion: @escaping ([VNRecognizedObjectObservation]?) -> Void) {
        guard let cgImage = image.cgImage else {
            print("CGImage로 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: detectionModel) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("결과를 가져올 수 없습니다.")
                completion(nil)
                return
            }
            completion(results)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("객체 인식 요청을 수행할 수 없습니다: \(error)")
                completion(nil)
            }
        }
    }
    
    func classifyObject(in image: UIImage, completion: @escaping (VNClassificationObservation?) -> Void) {
        guard let cgImage = image.cgImage else {
            print("CGImage로 변환할 수 없습니다.")
            completion(nil)
            return
        }
        
        let request = VNCoreMLRequest(model: classificationModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                print("분류 결과를 가져올 수 없습니다.")
                completion(nil)
                return
            }
            completion(topResult)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print("분류 요청을 수행할 수 없습니다: \(error)")
                completion(nil)
            }
        }
    }
    
    func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage, let croppedCGImage = cgImage.cropping(to: rect) else {
            return nil
        }
        return UIImage(cgImage: croppedCGImage)
    }
}
