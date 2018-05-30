//
//  S1MasterViewController.swift
//  RxSwift
//
//  Created by KARTHI on 30/05/18.
//  Copyright © 2018 impiger. All rights reserved.
//

import UIKit
import RxSwift

class S1MasterViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(self.editPressed(_:)))
        self.navigationItem.rightBarButtonItem = barButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func editPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "S1SelectViewControllerSegue", sender: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        if let vc = segue.destination as? S1SelectViewController {
            let subsriber = vc.seletedCharacter.subscribe(onNext: { [unowned self] (string) in
                debugPrint("➡️ OnNext")
                self.label.text = string
            }, onError: { (error) in
                debugPrint("❗️ Error - \(error.localizedDescription)")
            }, onCompleted: {
                debugPrint("✅ OnComplete")
            }, onDisposed: {
                debugPrint("🗑 OnDisposed")
            })
            subsriber.disposed(by: self.disposeBag)
        }
    }

}
