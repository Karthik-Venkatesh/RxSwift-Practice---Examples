//
//  S2MasterViewController.swift
//  RxSwiftTutorial
//
//  Created by Karthik Venkatesh on 05/06/18.
//  Copyright © 2018 impiger. All rights reserved.
//

import UIKit
import RxSwift

class S2MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var rows : [String] = ["Observable Sequences - 1", "Observable Sequences - 2", "Subjects - Publish Subject", "Tranformation - Map", "Tranformation - Flat Map","Tranformation - Scan", "Tranformation - Buffer", "Filter - Filter", "Filter - Distinct Until Changed", "Combine - Start With", "Combine - Merge", "Combine - Zip", "Side Effects", "Schedulers - Concurrent DispatchQueue Scheduler"]
    
    var helloSequence : Observable<String>?
    var helloCharSequence : Observable<[String]>?
    var publishSubjectSequence : PublishSubject<String>?
    
    let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeSequence()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UITableViewDataSource, UITabBarDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = rows[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.observableSequences1()
        case 1:
            self.observableSequences2()
        case 2:
            self.publishSubject()
        case 3:
            self.map()
        case 4:
            self.flatMap()
        case 5:
            self.scan()
        case 6:
            self.buffer()
        case 7:
            self.filter()
        case 8:
            self.distinctUntilChanged()
        case 9:
            self.startWith()
        case 10:
            self.merge()
        case 11:
            self.zip()
        case 12:
            self.sideEffects()
        case 13:
            self.concurrentDispatchQueueScheduler()
        default:
            break;
        }
    }

}

extension S2MasterViewController {
    
    func initializeSequence() {
        helloSequence = Observable.just("Hello")
        helloCharSequence = Observable.from(optional: ["H","e","l","l","o"])
        publishSubjectSequence = PublishSubject<String>()
    }
    
    func observableSequences1() {
        let subscription = helloSequence?.subscribe { (event) in
            print(event)
        }
        subscription?.disposed(by: self.bag)
    }
    
    func observableSequences2() {
        let subscription = helloCharSequence?.subscribe { (event) in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        subscription?.disposed(by: self.bag)
    }
    
    func publishSubject() {
        let subscription1 = publishSubjectSequence?.subscribe(onNext:{
            print($0)
        }).disposed(by: self.bag)
        // Subscription1 receives these 2 events, Subscription2 won't
        publishSubjectSequence?.onNext("Hello")
        publishSubjectSequence?.onNext("Again")
        // Sub2 will not get "Hello" and "Again" because it susbcribed later
        _ = publishSubjectSequence?.subscribe(onNext:{
            print(#line,$0)
        })
        publishSubjectSequence?.onNext("Both Subscriptions receive this message")
    }
    
    func map() {
        Observable<Int>.of(1,2,3,4).map { value in
            return value * 10
            }.subscribe(onNext:{
                print($0)
            }).disposed(by: self.bag)
    }
    
    func flatMap() {
        let sequence1  = Observable<Int>.of(1,3)
        let sequence2  = Observable<Int>.of(2,4)
        let sequenceOfSequences = Observable.of(sequence1,sequence2)
        sequenceOfSequences.flatMap{ return $0 }.subscribe(onNext:{
            print($0)
        }).dispose()
    }
    
    func scan() {
        Observable.of(1,2,3,4,5).scan(0) { seed, value in
            return seed + value
            }.subscribe(onNext:{
                print($0)
            }).dispose()
    }
    
    func buffer() {
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        Observable.of(1,2,3,4,5,6,7,8,9)
            .buffer(timeSpan: 150, count: 3, scheduler:concurrentScheduler)
            .subscribe(onNext:{
                print($0)
            }).dispose()
    }
    
    func filter() {
        Observable.of(2,30,22,5,60,1).filter{$0 > 10}.subscribe(onNext:{
            print($0)
        }).dispose()
    }
    
    func distinctUntilChanged() {
        Observable.of(1,2,2,1,3).distinctUntilChanged().subscribe(onNext:{
            print($0)
        }).dispose()
    }
    
    func startWith() {
        Observable.of(2,3).startWith(4).subscribe(onNext:{
            print($0)
        }).dispose()
    }
    
    func merge() {
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        let sub = Observable.of(publish1,publish2).merge().subscribe(onNext:{
            print($0)
        })
        publish1.onNext(20)
        publish1.onNext(40)
        publish1.onNext(60)
        publish2.onNext(1)
        publish1.onNext(80)
        publish2.onNext(2)
        publish1.onNext(100)
        sub.dispose()
    }
    
    func zip(){
        let a = Observable.of(1,2,3,4,5)
        let b = Observable.of("a","b","c","d")
        Observable.zip(a,b){ return ($0,$1) }.subscribe {
            print($0)
        }.dispose()
    }
    
    func sideEffects() {
        Observable.of(1,2,3,4,5).do(onNext: {
            $0 * 10 // This has no effect on the actual subscription
        }).subscribe(onNext:{
            print($0)
        }).dispose()
    }
    
    func concurrentDispatchQueueScheduler() {
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        Observable.of(publish1,publish2)
            .observeOn(concurrentScheduler)
            .merge()
            .subscribeOn(MainScheduler())
            .subscribe(onNext:{
                print($0)
            })
        publish1.onNext(20)
        publish1.onNext(40)
    }
}
