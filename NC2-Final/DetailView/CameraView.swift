//
//  CameraView.swift
//  NC2-Final
//
//  Created by 김하준 on 6/19/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        var photoOutput: AVCapturePhotoOutput?
        var previewLayer: AVCaptureVideoPreviewLayer?

        init(parent: CameraView) {
            self.parent = parent
            super.init()
            setupCaptureSession()
        }

        func setupCaptureSession() {
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .photo
            guard let backCamera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: backCamera) else {
                return
            }

            photoOutput = AVCapturePhotoOutput()
            photoOutput?.isHighResolutionCaptureEnabled = true

            if captureSession?.canAddInput(input) == true {
                captureSession?.addInput(input)
            }
            if captureSession?.canAddOutput(photoOutput!) == true {
                captureSession?.addOutput(photoOutput!)
            }

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = .resizeAspectFill
        }

        @objc func capturePhoto() {
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let data = photo.fileDataRepresentation(), let uiImage = UIImage(data: data) else {
                return
            }
            parent.image = uiImage
            parent.isShown = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.setupCaptureSession()
        
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = viewController.view.bounds
            viewController.view.layer.addSublayer(previewLayer)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.capturePhoto))
        viewController.view.addGestureRecognizer(tapGestureRecognizer)

        DispatchQueue.global(qos: .background).async {
            context.coordinator.captureSession?.startRunning()
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
