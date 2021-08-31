/*
 * JVDatePickerView
 * v1.0
 *
 * Copyright (c) 2021 Vithiea Hor (John)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
import JVCore

fileprivate let kNibName = "JVDatePicker"
fileprivate let kAnimationTime: Double = 0.25

public class JVDatePicker: UIView {
    @IBOutlet private var contentView:UIView!
    
    @IBOutlet public weak var datePicker: UIDatePicker!
    @IBOutlet public weak var btnDone: UIBarButtonItem!
    
    @IBOutlet private weak var viwDim: UIView!
    @IBOutlet private weak var viwPickerContainer: UIView!
    @IBOutlet private weak var viwPickerContainerBottom: NSLayoutConstraint!
    
    private var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private lazy var hiddenConstant: CGFloat = -(self.viwPickerContainer.frame.height+self.safeArea.bottom)
    
    public var didPickDate: ((JVDate)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialComponent()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialComponent()
        self.setupView()
    }
    
    private func initialComponent() {
        Bundle(for: type(of: self)).loadNibNamed(kNibName, owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    private func setupView() {
        
        // make it always clear color. use viwDim for black transparent
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.datePicker.datePickerMode = .date
        self.btnDone.title = "Done   "
        self.viwPickerContainerBottom.constant = self.hiddenConstant
        
        self.viwDim.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.viwDim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePicker)))
    }
    
    public func show() {
        //hide keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let window = UIApplication.shared.keyWindow!
        window.rootViewController!.view.addSubview(self)
        self.fillParent()
        
        // flyin animation not working when being presented immedialy after added into parent view.
        // delay to get the flyin animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: kAnimationTime) {
                self.viwDim.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.viwPickerContainerBottom.constant = 0
                self.superview!.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Actions
    @objc private func removePicker() {
        UIView.animate(withDuration: kAnimationTime) {
            self.viwDim.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.viwPickerContainerBottom.constant = self.hiddenConstant
            self.superview!.layoutIfNeeded()
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.removePicker()
        if let handler = self.didPickDate {
            handler(JVDate(self.datePicker.date))
        }
    }
}
