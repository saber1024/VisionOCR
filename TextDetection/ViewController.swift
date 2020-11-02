//
//  ViewController.swift
//  TextDetection
//
//  Created by edz on 2020/11/2.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController {

    var textLB : UILabel?
    
    let helper = LYIDCardOcrHeler.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        textLB = UILabel()
        textLB?.text = "11111"
        textLB?.translatesAutoresizingMaskIntoConstraints = false
        textLB?.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(textLB!)
        
        let btn = UIButton()
        btn.setTitle("选择照片", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(btn)
        
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        textLB?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textLB?.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        btn.topAnchor.constraint(equalTo: textLB!.bottomAnchor, constant: 30).isActive = true
        
        
        helper.delegate = self
        
    }
    
    @objc func btnAction()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        
    }
    
    
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        do{
            try  helper.starRecognition(img)
        }catch let error
        {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion: nil)
    }
}


extension ViewController: LYIDCardOcrPortocol
{
    func didDtectedIDNumber(idNum: String) {
        self.textLB?.text = idNum
    }
    
    func didFailedDetectNumber(error: Error) {
        print(error.localizedDescription)
    }
}
