//
//  CropViewController.swift
//  OneDay
//
//  Created by aa on 2021/7/22.
//

import UIKit
import JPImageresizerView

protocol CropViewControllerDelegate: AnyObject {
    func cropViewController(_ croper: CropViewController, imageDidFinishCrop cachePath: String)
    func dismissCropViewController()
}

class CropViewController: UIViewController {
    
    @IBOutlet weak var recoveryBtn: UIButton!
    @IBOutlet weak var operationView: UIView!
    
    private var imageresizerView: JPImageresizerView!
    
    weak var delegate: CropViewControllerDelegate? = nil
    
    var image: UIImage!
    var cachePath: String = ""
    var resizeWHScale: CGFloat = 0
    
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
        let configure = JPImageresizerConfigure.defaultConfigure(with: image) { c in
            _ = c
                .jp_viewFrame(frame)
                .jp_bgColor(.black)
                .jp_frameType(.classicFrameType)
                .jp_contentInsets(.init(top: 16, left: 16, bottom: 16, right: 16))
                .jp_animationCurve(.easeInOut)
                .jp_resizeWHScale(self.resizeWHScale)
                .jp_isArbitrarily(false)
                .jp_isShowGridlinesWhenDragging(true)
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
        delegate?.dismissCropViewController()
    }
    
    @IBAction func recover() {
        imageresizerView.recovery()
    }
    
    @IBAction func crop() {
        view.isUserInteractionEnabled = false
        
        File.manager.deleteFile(cachePath)
        
        imageresizerView.cropPicture(withCacheURL: URL(fileURLWithPath: cachePath), errorBlock: { [weak self] url, reason in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            File.manager.deleteFile(url?.path)
            JPrint("裁剪失败", reason)
        }) { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            
            guard let result = $0, result.isCacheSuccess else {
                self.delegate?.dismissCropViewController()
                return
            }
            
            self.delegate?.cropViewController(self, imageDidFinishCrop: result.cacheURL?.path ?? self.cachePath)
        }
    }
}
