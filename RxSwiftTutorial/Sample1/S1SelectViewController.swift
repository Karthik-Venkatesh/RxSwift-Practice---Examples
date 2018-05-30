//
//  S1SelectViewController.swift
//  RxSwift
//
//  Created by KARTHI on 30/05/18.
//  Copyright © 2018 impiger. All rights reserved.
//

import UIKit
import RxSwift

class S1SelectViewController: UIViewController {

    private let selectedCharacterVariable = Variable.init("🐶")
    
    var seletedCharacter : Observable<String> {
        return selectedCharacterVariable.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //🐶🐔🐴
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selected(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        selectedCharacterVariable.value = text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
