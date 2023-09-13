//
//  ImageProcessViewController.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/6.
//

import UIKit
import CoreVideo

class ImageProcessViewController: UIViewController {
    
    @IBOutlet weak var ZegoImagePreview: UIImageView!
    @IBOutlet weak var saveImageButton: UIButton!
    @IBOutlet weak var selectImageButton: UIButton!
    
    
    var processingImageMode: Bool = false {
        didSet {
            saveImageButton.isHidden = !processingImageMode
            selectImageButton.isHidden = processingImageMode
        }
    }
    var imageForProcessing: UIImage?
    var effectImage: UIImage?
    
    var gcdTimer: DispatchSourceTimer?
    
    lazy var beautySheet: ImageBeautifyView = {
        let beautySheet = ImageBeautifyView(frame: view.bounds)
        view.addSubview(beautySheet)
        beautySheet.isHidden = true
        return beautySheet
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func startGCDTimer() {
        if let gcdTimer = gcdTimer,
           !gcdTimer.isCancelled
        {
            gcdTimer.resume()
        } else {
            gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            gcdTimer?.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(100))
            gcdTimer?.setEventHandler { [weak self] in
                self?.renderImage()
            }
            gcdTimer?.resume()
        }
    }

    @IBAction func backButtonClick(_ sender: UIButton) {
        leaveImageProcessingMode()
        self.dismiss(animated: true)
    }
    
    @IBAction func effectButtonClick(_ sender: UIButton) {
        beautySheet.isHidden = false
    }
    
    @IBAction func selectImageButtonClick(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        enterImageProcessingMode()
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        guard let effectImage = ZegoImagePreview.image else { return }
        let cgImage: CGImage? = CIContext().createCGImage(effectImage.ciImage!, from: effectImage.ciImage!.extent) ?? nil
        guard let cgImage = cgImage else { return }
        let saveImage: UIImage = UIImage(cgImage: cgImage)
        UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(saveFinish), nil)
    }
    
    @objc func saveFinish(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        leaveImageProcessingMode()
        print("Save finished!")
    }
    
}

extension ImageProcessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageForProcessing = selectedImage
            ZegoSDKManager.shared.beautyService.uninitEnv()
            ZegoSDKManager.shared.beautyService.initEnv(selectedImage.size)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        leaveImageProcessingMode()
        picker.dismiss(animated: true)
    }
    
    func enterImageProcessingMode() {
        if (processingImageMode) {
          return;
        }
        processingImageMode = true;
        startGCDTimer()
    }
    
    func leaveImageProcessingMode() {
        if (!self.processingImageMode) {
            return;
        }
        self.processingImageMode = false;
        if let gcdTimer = gcdTimer,
           !gcdTimer.isCancelled
        {
            gcdTimer.cancel()
        }
        ZegoSDKManager.shared.beautyService.uninitEnv()
    }
    
    func renderImage() {
        guard let imageForProcessing = imageForProcessing else { return }
        print("Processing image...");
        let newBuffer: CVPixelBuffer? = ImageHelper.CVPixelBufferRefFromUiImage(imageForProcessing)
        guard let newBuffer = newBuffer else { return }
        ZegoSDKManager.shared.beautyService.processImageBuffer(newBuffer)
        let cimage: CIImage = CIImage(cvPixelBuffer: newBuffer)
        DispatchQueue.main.async {
            let image: UIImage = UIImage(ciImage: cimage)
            self.ZegoImagePreview.image = image
        }
    }
    

}
