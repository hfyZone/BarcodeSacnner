import UIKit
import AVFoundation

enum CameraError: String {
    case invalidDeviceInput = "invalid"
}



protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didiSurface(error: CameraError)
}

final class ScannerVC: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDeleget: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDeleget
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        let meteDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(meteDataOutput) {
            captureSession.addOutput(meteDataOutput)
            meteDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            meteDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didiSurface(error: .invalidDeviceInput)
            return
        }
        
        scannerDelegate?.didFind(barcode: barcode)
    }
}
