//
//  ViewController.swift
//  RxSwiftTutorial
//
//  Created by KARTHI on 30/05/18.
//  Copyright © 2018 impiger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var samlpe : [String] = ["Sample1", "Sample2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UITableViewDataSource, UITabBarDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.samlpe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = samlpe[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let st = UIStoryboard.init(name: "Sample1", bundle: nil)
            let vc = st.instantiateInitialViewController()
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let st = UIStoryboard.init(name: "Sample2", bundle: nil)
            let vc = st.instantiateInitialViewController()
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break;
        }
    }

}

