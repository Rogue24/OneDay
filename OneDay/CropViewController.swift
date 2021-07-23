//
//  CropViewController.swift
//  OneDay
//
//  Created by aa on 2021/7/22.
//

import UIKit
import JPImageresizerView
import WidgetKit

protocol CropViewControllerDelegate: AnyObject {
    func cropViewController(_ croper: CropViewController, imageDidFinishCrop iamge: UIImage?)
}

class CropViewController: UIViewController {
    
    @IBOutlet weak var recoveryBtn: UIButton!
    @IBOutlet weak var operationView: UIView!
    
    @IBOutlet weak var smallBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var largeBtn: UIButton!
    
    private var imageresizerView: JPImageresizerView!
    
    weak var delegate: CropViewControllerDelegate? = nil
    
    var image: UIImage!
    var family: WidgetFamily = .systemSmall
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var statusBarH: CGFloat = 0
        var diffTabBarH: CGFloat = 0
        if let window = view.window {
            if let statusBarManager = view.window?.windowScene?.statusBarManager {
                statusBarH = statusBarManager.statusBarFrame.height
            } else {
                statusBarH = window.safeAreaInsets.top
            }
            diffTabBarH = window.safeAreaInsets.bottom
        }
        
        let frame = CGRect(x: 0, y: statusBarH, width: PortraitScreenWidth, height: PortraitScreenHeight - statusBarH - diffTabBarH - 100)
        
        // 1.初始配置
        let imageSize = family.jp.imageSize
        let configure = JPImageresizerConfigure.defaultConfigure(with: image) { c in
            _ = c
                .jp_viewFrame(frame)
                .jp_bgColor(.black)
                .jp_frameType(.classicFrameType)
                .jp_contentInsets(.init(top: 16, left: 16, bottom: 16, right: 16))
                .jp_animationCurve(.easeInOut)
                .jp_resizeWHScale(imageSize.width / imageSize.height)
                .jp_isArbitrarily(false)
        }

        // 2.创建imageresizerView
        let imageresizerView = JPImageresizerView(configure: configure) { [weak self] isCanRecovery in
            // 当不需要重置设置按钮不可点
            self?.recoveryBtn.isEnabled = isCanRecovery
        } imageresizerIsPrepareToScale: { [weak self] isPrepareToScale in
            // 当预备缩放设置按钮不可点，结束后可点击
            self?.operationView.isUserInteractionEnabled = !isPrepareToScale
        }

        // 3.添加到视图上
        view.insertSubview(imageresizerView, at: 0)
        self.imageresizerView = imageresizerView
        
        smallBtn.isSelected = family == .systemSmall
        mediumBtn.isSelected = family == .systemMedium
        largeBtn.isSelected = family == .systemLarge
    }
}

// MARK:- 监听Button（旋转）
extension CropViewController {
    @IBAction func rotateLeft() {
        imageresizerView.isClockwiseRotation = false
        imageresizerView.rotation()
    }
    
    @IBAction func rotateRight() {
        imageresizerView.isClockwiseRotation = true
        imageresizerView.rotation()
    }
}

// MARK:- 监听返回/恢复/裁剪事件
extension CropViewController {
    @IBAction func goBack() {
        delegate?.cropViewController(self, imageDidFinishCrop: nil)
    }
    
    @IBAction func recover() {
        imageresizerView.recovery()
    }
    
    @IBAction func crop() {
        view.isUserInteractionEnabled = false
        File.manager.deleteFile(family.jp.imageCachePath)
        imageresizerView.cropPicture(withCacheURL: URL(fileURLWithPath: family.jp.imageCachePath), errorBlock: { url, reason in
            File.manager.deleteFile(url?.path)
            JPrint("裁剪失败", reason)
        }) { [weak self] result in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            self.delegate?.cropViewController(self, imageDidFinishCrop: result?.image)
        }
    }
}

// MARK:- 监听比例切换事件
extension CropViewController {
    private func setFamily(_ family: WidgetFamily) {
        self.family = family
        smallBtn.isSelected = family == .systemSmall
        mediumBtn.isSelected = family == .systemMedium
        largeBtn.isSelected = family == .systemLarge
        
        let imageSize = family.jp.imageSize
        imageresizerView.resizeWHScale = imageSize.width / imageSize.height
    }
    
    @IBAction func smallScale() {
        setFamily(.systemSmall)
    }
    
    @IBAction func mediumScale() {
        setFamily(.systemMedium)
    }
    
    @IBAction func largeScale() {
        setFamily(.systemLarge)
    }
}
