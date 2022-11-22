//
//  QWRXViewController.swift
//  ForSwift
//
//  Created by qinwen on 2022/10/6.
//

import UIKit
import RxSwift
import RxCocoa
import JFPopup
import RxRelay


class QWRXSwiftViewController: QWBaseViewController {
    lazy var label = UILabel().then {
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    private let subject = PublishSubject<Int>()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview()
        }
        
  
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
    }
    
    ///创建Observable
    func createObservableTest() {
        ///just传入默认值
        _ = Observable<Int>.just(1)
        
        ///of接收可变数量参数
        _ = Observable.of("A", "B", "C")
        
        ///from传入数组
        _ = Observable.from(["A", "B", "C"])
        
        ///empty创建空内容的observable序列
        _ = Observable<Any>.empty()
        
        ///never创建一个永远不会发出 Event（也不会终止）的 Observable 序列
        _ = Observable<Any>.never()
        
        ///error创建一个不做任何操作，而是直接发送一个错误的 Observable 序列
        _ = Observable<Any>.error(MyError.A)
        
        ///range创建一个以range内所有值作为初始值的 Observable 序列
        _ = Observable.range(start: 1, count: 5)
        
        ///repeatElement创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）
        _ = Observable.repeatElement(1, scheduler: MainScheduler.instance)
        
        ///generate创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列
        _ = Observable.generate(initialState: 0, condition: {$0 <= 10}, iterate: {$0+2})//0,2,4,6,8,10
        
        ///create接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理
        let observable = Observable<String>.create { observer in
            observer.onNext("abc")
            observer.onCompleted()
            
            return Disposables.create()
        }
        observable.subscribe({
            print($0)
        }).disposed(by: bag)
        
        ///deferred相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable 序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方
        //用于标记是奇数、还是偶数
        var isOdd = true
        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
        let factory : Observable<Int> = Observable.deferred {
            //让每次执行这个block时候都会让奇、偶数进行交替
            isOdd = !isOdd
            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
            if isOdd {
                return Observable.of(1, 3, 5 ,7)
            }else {
                return Observable.of(2, 4, 6, 8)
            }
        }
        //第1次订阅测试
        factory.subscribe { event in
            print("\(isOdd)", event)
        }.disposed(by: bag)
        //第2次订阅测试
        factory.subscribe { event in
            print("\(isOdd)", event)
        }.disposed(by: bag)
        
        ///interval创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去
        let observable2 = Observable<Int>.interval(DispatchTimeInterval.seconds(2), scheduler: MainScheduler.instance)
        observable2.subscribe {
            print($0)
        }.disposed(by: bag)
        
        ///timer有两种用法，一种是创建的 Observable 序列在经过设定的一段时间后，产生唯一的一个元素
        let observable3 = Observable<Int>.timer(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        observable3.subscribe({
            print($0)
        }).disposed(by: bag)
        ///另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
        let observable4 = Observable<Int>.timer(RxTimeInterval.seconds(5), period: RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        observable4.subscribe({
            print($0)
        }).disposed(by: bag)
    }
    
    ///监听事件的生命周期
    func eventLifeCycleTest() {
        let observale = Observable.of(1, 2, 3)
        observale.do { e in
            print("onNext:\(e)")
        } afterNext: { e in
            print("afterNext:\(e)")
        } onError: { e in
            print("onError:\(e)")
        } afterError: { e in
            print("afterError:\(e)")
        } onCompleted: {
            print("onCompleted")
        } afterCompleted: {
            print("afterCompleted")
        } onSubscribe: {
            print("onSubscribe")
        } onSubscribed: {
            print("onSubscribed")
        } onDispose: {
            print("onDispose")
        }.subscribe { event in
            print("订阅回调\(event)")
        }.disposed(by: bag)

    }
    
    ///使用AnyObserver创建观察者
    func anyObserverTest() {
        let observer: AnyObserver<Int> = AnyObserver { event in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        
        Observable.of(1, 2, 3).subscribe(observer).disposed(by: bag)
    }
    
   ///使用 Binder 创建观察者
    func binderTest() {
//        （1）相较于 AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
//        不会处理错误事件
//        确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
//        （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
        
        label.isHidden = false
        
        let observer: Binder<String> = Binder(label) { view, text in
            view.text = text
        }
        
        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map {
            "当前索引数：\($0 )"
        }.subscribe(observer).disposed(by: bag)
    }
    
    ///使用 Binder 创建自定义观察者
    func customObserverWithBinderTest() {
        label.isHidden = false
        label.text = "test"
        
//        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map { CGFloat($0)
//        }.subscribe(label.fontSize).disposed(by: bag)
        Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map { CGFloat($0)
        }.subscribe(label.rx.fontSize).disposed(by: bag)
    }
    
    ///PublishSubject
    func publishSubjectTest() {
//        PublishSubject 是最普通的 Subject，它不需要初始值就能创建。
//        PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
        let subject = PublishSubject<String>()
        subject.onNext("111")
        subject.subscribe {
            print("第一次订阅onNext:\($0)")
        } onCompleted: {
            print("第一次订阅onCompleted")
        }.disposed(by: bag)

        subject.onNext("222")
        
        subject.subscribe {
            print("第二次订阅onNext:\($0)")
        } onCompleted: {
            print("第二次订阅onCompleted")
        }.disposed(by: bag)
        
        subject.onNext("333")
        subject.onCompleted()
        subject.onNext("444")
        
        subject.subscribe {
            print("第三次订阅onNext:\($0)")
        } onCompleted: {
            print("第三次订阅onCompleted")
        }.disposed(by: bag)
        
    }
    
    ///BehaviorSubject
    func behaviorSubjectTest() {
//        BehaviorSubject 需要通过一个默认初始值来创建。
//        当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的 event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
        let subject = BehaviorSubject(value: "111")
     
        subject.subscribe {
            print("第一次订阅onNext:\($0)")
        } onCompleted: {
            print("第一次订阅onCompleted")
        }.disposed(by: bag)

        subject.onNext("222")
        
        subject.subscribe {
            print("第二次订阅onNext:\($0)")
        } onCompleted: {
            print("第二次订阅onCompleted")
        }.disposed(by: bag)
        
        subject.onNext("333")
        subject.onCompleted()
        subject.onNext("444")
        
        subject.subscribe {
            print("第三次订阅onNext:\($0)")
        } onCompleted: {
            print("第三次订阅onCompleted")
        }.disposed(by: bag)
    }
    
    ///ReplaySubject
    func replaySubjectTest() {
//        ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
//        比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个 .next 的 event。
//        如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event 外，还会收到那个终结的 .error 或者 .complete 的 event。
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        subject.subscribe { event in
            print("第1次订阅：\(event)")
        }.disposed(by: bag)
        
        subject.onNext("444")
        
        subject.subscribe { event in
            print("第2次订阅：\(event)")
        }.disposed(by: bag)
        
        subject.onCompleted()
        
        subject.subscribe { event in
            print("第3次订阅：\(event)")
        }.disposed(by: bag)
    }
    
    ///BehaviorRelay
    func behaviorRelayTest() {
//        BehaviorRelay本质其实是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
//        BehaviorRelay 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
//        与 BehaviorSubject 不同的是，不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它（BehaviorRelay 会在销毁时也不会自动发送 .complete 的 event）。
//        BehaviorRelay 有一个 value 属性，我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改。
        let relay = BehaviorRelay(value: "111")
        relay.accept("222")
        
        relay.subscribe {
            print("第1次订阅：\($0)")
        }.disposed(by: bag)
        
        relay.accept("333")
        
        relay.subscribe {
            print("第2次订阅：\($0)")
        }.disposed(by: bag)
        
        relay.accept("444")
        bag
    }
 
    
//MARK: 变换操作
    ///变换操作-buffer
    func transformingForBufferTest() {
//        buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
//        该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。

        let subject = PublishSubject<String>()
        subject.buffer(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance).subscribe({print($0)}).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")

        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            [weak subject] in
            subject?.onCompleted()
        }
    }
    
    ///变换操作-window
    func transformingForWindowTest() {
//        window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
//        同时 buffer 要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。

        let subject = PublishSubject<String>()
        subject.window(timeSpan: RxTimeInterval.seconds(1), count: 3, scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] in
            print("外层：\($0)")
            $0.asObservable().subscribe {
                print(" 内层：\($0)")
            }.disposed(by: self!.bag)
        }).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")

        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            [weak subject] in
            subject?.onCompleted()
        }
    }
    
    ///变换操作-map
    func transformingForMapTest() {
        //该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列
        Observable.of(1, 2, 3).map {
            "abc:\($0)"
        }.subscribe {
            print($0)
        }.disposed(by: bag)
    }
    
    ///变换操作-flatMap
    func transformingForFlatMapTest() {
//        map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
//        而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
//        这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
//        flatMap() = map() + merge
        
        let relay1 = BehaviorRelay(value: "1")
        let relay2 = BehaviorRelay(value: "a")
        let subject = PublishSubject<BehaviorRelay<String>>()
        subject.flatMap {
            $0
        }.subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject.onNext(relay1)
        relay1.accept("2")
        subject.onNext(relay2)
        relay1.accept("3")
        relay2.accept("b")
        
        
    }
    
    ///变换操作-flatMapLatest
    func transformingForFlatMapLatestTest() {
//        flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件。
        let relay1 = BehaviorRelay(value: "1")
        let relay2 = BehaviorRelay(value: "a")
        let subject = PublishSubject<BehaviorRelay<String>>()
        subject.flatMapLatest {
            $0
        }.subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject.onNext(relay1)
        relay1.accept("2")
        subject.onNext(relay2)
        relay1.accept("3")
        relay2.accept("b")
        
    }
    
    ///变换操作-flatMapFirst
    func transformingForFlatMapFirstTest() {
//        flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件。
        let relay1 = BehaviorRelay(value: "1")
        let relay2 = BehaviorRelay(value: "a")
        let subject = PublishSubject<BehaviorRelay<String>>()
        subject.flatMapFirst {
            $0
        }.subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject.onNext(relay1)
        relay1.accept("2")
        subject.onNext(relay2)
        relay1.accept("3")
        relay2.accept("b")
    }
    
    ///变换操作-concatMap
    func transformingForConcatMapTest() {
//        concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
        let p1 = BehaviorSubject(value: "1")
        let p2 = BehaviorSubject(value: "a")
        let subject = PublishSubject<BehaviorSubject<String>>()
        subject.concatMap {
            $0
        }.subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject.onNext(p1)
        p1.onNext("2")
        subject.onNext(p2)

        p1.onNext("3")
        p2.onNext("b")
        p2.onNext("c")
        p1.onCompleted()//只有前一个序列结束后，才能接收下一个序列
    }
    
    ///变换操作-scan
    func transformingForScanTest() {
//        scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
        Observable.of(1,2,3,4,5).scan(0) {
            $0 + $1
        }.subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///变换操作-groupBy
    func transformingForGroupByTest() {
//        groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
//        也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
        Observable.of(1,2,3,4,5).groupBy {
            return $0 % 2 == 0 ? "偶数" : "奇数"
        }.subscribe {[weak self] event in
            switch event {
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            case .next(let group):
                group.subscribe{
                    print("key:\(group.key) event:\($0)")
                }.disposed(by: self!.bag)
            }
        }.disposed(by: bag)

    }
    
//MARK: 过滤操作
    ///过滤操作-filter
    func filterForFilterTest() {
//        该操作符就是用来过滤掉某些不符合要求的事件
        Observable.of(2,3,6,9,1,10,7).filter{
            $0 > 5
        }.subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-distinctUntilChanged
    func filterForDistinctUntilChangedTest() {
//        该操作符用于过滤掉连续重复的事件
        Observable.of(2,2,6,6,6,10,7,7,9).distinctUntilChanged().subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-single
    func filterForSingleTest() {
//        限制只发送一次事件，或者满足条件的第一个事件。
//        如果存在有多个事件或者没有事件都会发出一个 error 事件。
//        如果只有一个事件，则不会发出 error 事件。
        Observable.of(2,3,4,5).single{
            $0 == 5
        }.subscribe{
            print("只有一个满足条件的事件时：\($0)")
        }.disposed(by: bag)
        print("========================")
        Observable.of(2,3,4,5).single{
            $0 > 5
        }.subscribe{
            print("没有满足条件的事件时：\($0)")
        }.disposed(by: bag)
        print("========================")
        Observable.of(2,3,4,5).single{
            $0 < 5
        }.subscribe{
            print("有多个满足条件的事件时：\($0)")
        }.disposed(by: bag)
    }
    
    ///过滤操作-elementAt
    func filterForElementAtTest() {
//        该方法实现只处理在指定位置的事件
        Observable.of(0,1,2,3,4,5).element(at: 3).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-ignoreElements
    func filterForIgnoreElementsTest() {
//        该操作符可以忽略掉所有的元素，只发出 error 或 completed 事件。
//        如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
        Observable.of(0,1,2,3,4,5).ignoreElements().subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-take
    func filterForTakeTest() {
//        该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed
        Observable.of(0,1,2,3,4,5).take(2).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-takeLast
    func filterForTakeLastTest() {
//        该方法实现仅发送 Observable 序列中的后 n 个事件
        Observable.of(0,1,2,3,4,5).takeLast(2).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-skip(跟take互补)
    func filterForSkipTest() {
//        该方法用于跳过源 Observable 序列发出的前 n 个事件
        Observable.of(0,1,2,3,4,5).skip(2).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///过滤操作-sample(采样,notifier控制采样频率)
    func filterForSampleTest() {
//        Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier 。
//        每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier).subscribe{
            print($0)
        }.disposed(by: bag)
        
        source.onNext(1)
        
        notifier.onNext("A")
        
        source.onNext(2)
        
        notifier.onNext("B")
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        notifier.onNext("D")
        
        source.onNext(5)
        
        notifier.onCompleted()
    }
    
    ///过滤操作-debounce(防抖)
    func filterForDebounceTest() {
//        debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
//        换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
//        debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
        let times = [["value": 1, "time": 0.1],
                     ["value": 2, "time": 1.1],
                     ["value": 3, "time": 1.2],
                     ["value": 4, "time": 1.3],
                     ["value": 5, "time": 1.4],
                     ["value": 6, "time": 2.1],
        ]
        
        Observable.from(times).flatMap{
            return Observable.of(Int($0["value"] ?? 0)).delaySubscription(RxTimeInterval.milliseconds(Int(($0["time"] ?? 0) * 1000)), scheduler: MainScheduler.instance)
        }.debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe{
            print($0)
        }.disposed(by: bag)
    }
 
//MARK: 条件和布尔操作
    ///条件和布尔操作-amb
    func conditionAndBoolForAmbTest() {
//        当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1.amb(subject2).amb(subject3).subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject2.onNext(20)
        subject1.onNext(10)
        subject3.onNext(30)
        subject3.onNext(31)
        subject3.onNext(32)
        subject1.onNext(11)
        subject2.onNext(21)
        subject2.onNext(22)
        subject1.onNext(12)
    }
    
    ///条件和布尔操作-takeWhile
    func conditionAndBoolForTakeWhileTest() {
//        该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
        Observable.of(1,2,3,4,5).take(while: {$0 < 3}).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///条件和布尔操作-takeUntil
    func conditionAndBoolForTakeUntilTest() {
//        除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
//        如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.take(until: notifier).subscribe {
            print($0)
        }.disposed(by: bag)
        
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        
        notifier.onNext("a")
        
        source.onNext(5)
        source.onNext(6)
    }
    
    ///条件和布尔操作-skipWhile
    func conditionAndBoolForSkipWhileTest() {
//        该方法用于跳过前面所有满足条件的事件。
//        一旦遇到不满足条件的事件，之后就不会再跳过了。
        Observable.of(1,3,5,7,2,4,6).skip {
            $0 <= 5
        }.subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///条件和布尔操作-skipUntil(与takeUntil相反)
    func conditionAndBoolForSkipUntilTest() {
//        同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，通过 skipUntil 方法我们还可以监视另外一个 Observable， 即 notifier 。
//        与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.skip(until: notifier).subscribe {
            print($0)
        }.disposed(by: bag)
        
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        
        notifier.onNext("a")
        
        source.onNext(5)
        source.onNext(6)
        
        notifier.onCompleted()//仍然接收消息
        
        source.onNext(7)
        source.onNext(8)
    }
    
//MARK: 结合操作
    ///结合操作-startWith
    func combiningForStartWithTest() {
//        该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息
        Observable.of(3,4).startWith(1,2).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///结合操作-merge
    func combiningForMergeTest() {
//        该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable 序列
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.of(subject1,subject2).merge().subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject1.onNext(1)
        subject2.onNext(10)
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext(20)
        subject2.onNext(30)
    }
    
    ///结合操作-zip
    func combiningForZipTest() {
//        该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable 序列
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
    
        Observable.zip(subject1, subject2){
            "\($0)_\($1)"
        } .subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject2.onNext("A")
        subject1.onNext(1)
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext("B")
        subject2.onNext("C")
    }
    
    ///结合操作-combineLatest
    func combiningForCombineLatestTest() {
//        该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
//        但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
    
        Observable.combineLatest(subject1, subject2){
            "\($0)_\($1)"
        } .subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject2.onNext("A")
        subject1.onNext(1)
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext("B")
        subject2.onNext("C")
    }
    
    ///结合操作-withLatestFrom
    func combiningForWithLatestFromTest() {
//        该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
    
        subject1.withLatestFrom(subject2).subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject2.onNext("A")
        subject1.onNext(1)
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext("B")
        subject2.onNext("C")
        subject1.onNext(4)
    }
    
    
    ///结合操作-switchLatest
    func combiningForSwitchLatestTest() {
        //        switchLatest 有点像其他语言的 switch 方法，可以对事件流进行转换。
        //        比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2。
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let behaviorRelay = BehaviorRelay(value: subject1)
        
        behaviorRelay.switchLatest().subscribe{
            print($0)
        }.disposed(by: bag)
        
        
        subject1.onNext("B")
        subject1.onNext("C")
        
        //改变事件源
        behaviorRelay.accept(subject2)
        subject1.onNext("D")
        subject2.onNext("2")
        
        //改变事件源
        behaviorRelay.accept(subject1)
        subject2.onNext("3")
        subject1.onNext("E")
        //A B C 1 2 D E
    }
    
//MARK: 算数、以及聚合操作操作
    ///算数、以及聚合操作操作-toArray
    func mathematicalAndAggregateForToArrayTest() {
//        该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束
        Observable.of(1,3,4).toArray().subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///算数、以及聚合操作操作-reduce
    func mathematicalAndAggregateForReduceTest() {
//        reduce 接受一个初始值，和一个操作符号。
//        reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去。

        Observable.of(1,2,3,4,5).reduce(100){
            $0 + $1
        }.subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///算数、以及聚合操作操作-concat（串联）
    func mathematicalAndAggregateForConcatTest() {
//        concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。
//        并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个 Observable 序列事件
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        subject1.concat(subject2).subscribe{
            print($0)
        }.disposed(by: bag)
        
        subject2.onNext(20)
        subject2.onNext(21)
        
        subject1.onNext(10)
        subject1.onNext(11)
        
        subject1.onCompleted()
        
        subject2.onNext(22)
        
    }
    
//MARK: 连接操作
//    可连接的序列（Connectable Observable）：
//    （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect() 之后才会开始发送值。
//    （2）可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息。

        ///连接操作-publish
        func connectableForPublishTest() {
//            publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始
            let subject = PublishSubject<Int>()
            let connectable = subject.publish()
            
            connectable.subscribe{
                print("订阅1 \($0)")
            }.disposed(by: bag)
            
            
            subject.onNext(1)
            
            connectable.subscribe{
                print("订阅2 \($0)")
            }.disposed(by: bag)
            
            subject.onNext(2)
            
            connectable.connect().disposed(by: bag)
            
            connectable.subscribe{
                print("订阅3 \($0)")
            }.disposed(by: bag)
            subject.onNext(3)
        }
    
    ///连接操作-replay
    func connectableForReplayTest() {
//        replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
//        replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）
        let subject = PublishSubject<Int>()
        let connectable = subject.replay(3)
        
        connectable.subscribe{
            print("订阅1 \($0)")
        }.disposed(by: bag)
        
        
        subject.onNext(1)
        
        connectable.subscribe{
            print("订阅2 \($0)")
        }.disposed(by: bag)
        
        subject.onNext(2)
        
        connectable.connect().disposed(by: bag)
        subject.onNext(3)
        subject.onNext(4)
        
        connectable.subscribe{
            print("订阅3 \($0)")
        }.disposed(by: bag)
        subject.onNext(5)
    }
    
    
    ///连接操作-multicast
    func connectableForMulticastTest() {
//        multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
//        同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送

        let inputSubject = PublishSubject<Int>()
        inputSubject.subscribe{
            print("inputSubject \($0)")
        }.disposed(by: bag)

        let subject = PublishSubject<Int>()
        let connectable = subject.multicast(inputSubject)
        
        connectable.subscribe{
            print("订阅1 \($0)")
        }.disposed(by: bag)
        
        
        subject.onNext(1)
        
        connectable.subscribe{
            print("订阅2 \($0)")
        }.disposed(by: bag)
        
        subject.onNext(2)
        
        connectable.connect().disposed(by: bag)
        subject.onNext(3)
        subject.onNext(4)
        
        connectable.subscribe{
            print("订阅3 \($0)")
        }.disposed(by: bag)
        subject.onNext(5)
    }
    
    ///连接操作-refCount
    func connectableForRefCountTest() {
//        refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
//        即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的 Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接
        let subject = PublishSubject<Int>()
        let connectable = subject.publish().refCount()
        
        connectable.subscribe{
            print("订阅1 \($0)")
        }.disposed(by: bag)
        
        
        subject.onNext(1)
        
        connectable.subscribe{
            print("订阅2 \($0)")
        }.disposed(by: bag)
        
        subject.onNext(2)

        connectable.subscribe{
            print("订阅3 \($0)")
        }.disposed(by: bag)
        subject.onNext(3)
    }
    
    ///连接操作-share(replay:)
    func connectableForShareTest() {
//        该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
//        简单来说 shareReplay 就是 replay 和 refCount 的组合
        let subject = PublishSubject<Int>()
        let connectable = subject.share(replay: 3)
        
        connectable.subscribe{
            print("订阅1 \($0)")
        }.disposed(by: bag)
        
        
        subject.onNext(1)
        
        connectable.subscribe{
            print("订阅2 \($0)")
        }.disposed(by: bag)
        
        subject.onNext(2)

        connectable.subscribe{
            print("订阅3 \($0)")
        }.disposed(by: bag)
        subject.onNext(3)
    }
    
//MARK: 其他操作
    ///其他操作-delay
    func delayTest() {
//        该操作符会将 Observable 的所有元素都先拖延一段设定好的时间，然后才将它们发送出来
        print(NSDate())
        Observable.of(1,2,3).delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance).subscribe{
            print("\(NSDate()):\($0)")
        }.disposed(by: bag)

    }
    
    ///其他操作-delaySubscription
    func delaySubscriptionTest() {
//        使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作
        print(NSDate())
        Observable.of(1,2,3).delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance).subscribe{
            print("\(NSDate()):\($0)")
        }.disposed(by: bag)

    }
    
    ///其他操作-materialize
    func materializeTest() {
//        该操作符可以将序列产生的事件，转换成元素。
//        通常一个有限的 Observable 将产生零个或者多个 onNext 事件，最后产生一个 onCompleted 或者 onError 事件。而 materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来
        Observable.of(1,2,3).materialize().subscribe{
            print($0)
        }.disposed(by: bag)

    }
    
    ///其他操作-dematerialize(跟materialize相反)
    func dematerializeTest() {
//        该操作符的作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原
        Observable.of(1,2,3).materialize().dematerialize().subscribe{
            print($0)
        }.disposed(by: bag)

    }
    
    ///其他操作-timeout
    func timeoutTest() {
//        使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件
        
        let times = [["value": 1, "interval": 0],
                   ["value": 2, "interval": 0.5],
                   ["value": 3, "interval": 1.5],
                   ["value": 4, "interval": 4],
                   ["value": 5, "interval": 5],
        ]
        
        Observable.from(times).flatMap { map in
            return Observable.of(map["value"]).delaySubscription(RxTimeInterval.milliseconds(Int((map["interval"] ?? 0) * 1000)), scheduler: MainScheduler.instance)
        }.timeout(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance).subscribe{
            print($0)
        }.disposed(by: bag)

    }
    
    
    ///其他操作-using
    func usingTest() {
//        使用 using 操作符创建 Observable 时，同时会创建一个可被清除的资源，一旦 Observable 终止了，那么这个资源就会被清除掉了
        
        let infiniteInterval = Observable<Int>.interval(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance).do {
            print("infinite onNext: \($0)")
        } onSubscribe: {
            print("开始订阅 infinite")
        }  onDispose: {
            print("销毁 infinite")
        }

        let limited = Observable<Int>.interval(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).take(2).do {
            print("limited onNext: \($0)")
        } onSubscribe: {
            print("开始订阅 limited")
        }  onDispose: {
            print("销毁 limited")
        }

        //使用using操作符创建序列
        let o: Observable<Int> = Observable.using({ () -> AnyDisposable in
            return AnyDisposable(infiniteInterval.subscribe())
        }, observableFactory: { _ in return limited }
        )
        o.subscribe().disposed(by: bag)
    }

//MARK: 错误处理
    ///错误处理-catchAndReturn
    func catchAndReturnTest() {
//        当遇到 error 事件的时候，就返回指定的值，然后结束

        let subject = PublishSubject<String>()
        
        subject.catchAndReturn("自定义错误").subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onError(MyError.A)
        subject.onNext("d")
    }
    
    ///错误处理-catchError
    func catchErrorTest() {
//        该方法可以捕获 error，并对其进行处理。
//        同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）

        let subject = PublishSubject<String>()
        let recoverySequence = Observable.of("1","2","3")
        
        subject.catch{
            print("catch error: \($0)")
            return recoverySequence
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: bag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onError(MyError.A)
        subject.onNext("d")
    }
    
    ///错误处理-retry
    func retryTest() {
//        使用该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接。
//        retry() 方法可以传入数字表示重试次数。不传的话只会重试一次

        var count = 1
         
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
             
            //让第一个订阅时发生错误
            if count == 1 {
                observer.onError(MyError.A)
                print("Error encountered")
                count += 1
            }
             
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
             
            return Disposables.create()
        }
         
        sequenceThatErrors
            .retry(2)  //重试2次（参数为空则只重试一次）
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)
    }
    
//MARK: 调试操作
    ///调试操作-debug
    func debugTest() {
//        我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试
        
        Observable.of(1,2,3).startWith(888).debug("调试1：", trimOutput: true).subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
    ///调试操作-Resources.total
    func resourcesTotalTest() {
//        通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用
#if TRACE_RESOURCES
        print(123456)
        print(Resources.total)
#endif
        Observable.of(1,2,3).startWith(888).subscribe{
            print($0)
        }.disposed(by: bag)
#if TRACE_RESOURCES
        print(Resources.total)
#endif
    }
  
//MARK: 特征序列（Traits）
//    我们可以将这些 Traits 看作是 Observable 的另外一个版本。它们之间的区别是：
//    Observable 是能够用于任何上下文环境的通用序列。
//    而 Traits 可以帮助我们更准确的描述序列。同时它们还为我们提供上下文含义、语法糖，让我们能够用更加优雅的方式书写代码。
    
    ///特征序列-Single
    func singleTest() {
        //        Single 是 Observable 的另外一个版本。但它不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件
        let single = Single<[String: Any]>.create { single in
            let url = "https://douban.fm/j/mine/playlist?" + "type=n&channel=0&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    single(SingleEvent.failure(error))
                    return
                }
                
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves), let result = json as? [String: Any] else {
                    single(SingleEvent.failure(DataError.cantParseJSON))
                    return
                }
                
                single(SingleEvent.success(result))
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
        
        single.subscribe { result in
            print("result:\(result)")
        } onFailure: { error in
            print("error:\(error)")
        }.disposed(by: bag)

    }
    
    func asSingleTest() {
//        我们可以通过调用 Observable 序列的 .asSingle() 方法，将它转换为 Single
        //一个失败案例
        Observable.of(1,2,3).asSingle().subscribe{
            print($0)
        }.disposed(by: bag)
        
        print("~~~~~~~~~~~~~~~~~~~~~~~")
        
        //一个成功案例
        Observable.of(1).asSingle().subscribe{
            print($0)
        }.disposed(by: bag)
    }


    ///特征序列-Completable
    func completableTest() {
        //    Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。
        //    不会发出任何元素
        //    只会发出一个 completed 事件或者一个 error 事件
        //    不会共享状态变化
        
        let completable = Completable.create { completable in
            //模拟将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
            let success = arc4random() % 2 == 0
            guard success else {
                completable(CompletableEvent.error(CacheError.failedCaching))
                return Disposables.create()
            }
            
            completable(CompletableEvent.completed)
            
            return Disposables.create()
        }
        
        completable.subscribe {
            print("保存成功")
        } onError: { error in
            print("保存失败: \(error.localizedDescription)")
        }.disposed(by: bag)
    }

    ///特征序列-Maybe
    func maybeTest() {
//        Maybe 同样是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
//        发出一个元素、或者一个 completed 事件、或者一个 error 事件
//        不会共享状态变化
        let maybe = Maybe<Int>.create { maybe in
            let random = Int.random(in: 1...9)
            
            if random <= 3 {
                maybe(MaybeEvent.success(random))
                return Disposables.create()
            }
            
            if random <= 6 {
                maybe(MaybeEvent.completed)
                return Disposables.create()
            }
            
            maybe(MaybeEvent.error(CacheError.failedCaching))
            return Disposables.create()
        }
    
        maybe.subscribe { success in
            print("success: \(success)")
        } onError: { error in
            print("error: \(error)")
        } onCompleted: {
            print("complete")
        }.disposed(by: bag)

    }
    
    func asMaybeTest() {
//        我们可以通过调用 Observable 序列的 .asMaybe() 方法，将它转换为 Maybe
        //一个失败案例
        Observable.of(1,2,3).asMaybe().subscribe{
            print($0)
        }.disposed(by: bag)
        
        print("~~~~~~~~~~~~~~~~~~~~~~~")
        
        //一个成功案例
        Observable.of(1).asMaybe().subscribe{
            print($0)
        }.disposed(by: bag)
    }
    
//MARK: Private Method
    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
//MARK: Override Method
    override func writeNote() {
        super.writeNote()
        note.append(contentsOf: "rx的作用：\n统一各种异步事件（delegate、notification、target-action、KVO）的处理方式，全部替换成 Rx 的“信号链”方式；\n方便MVVM开发模式下的数据双向绑定。\n\n")
        note.append(contentsOf: "RXSwift与RXCocoa的关系：\nRxSwift：它只是基于 Swift 语言的 Rx 标准实现接口库，所以 RxSwift 里不包含任何 Cocoa 或者 UI 方面的类。\nRxCocoa：是基于 RxSwift 针对于 iOS 开发的一个库，它通过 Extension 的方法给原生的比如 UI 控件添加了 Rx 的特性，使得我们更容易订阅和响应这些控件的事件。\n\n")
        note.append(contentsOf: "observable的生命周期：\n1、一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它\n2、Observable 序列激活之后要一直等到它发出了 .error 或者 .completed 的 event 后，它才被终结\n3、使用dispose方法我们可以手动取消一个订阅行为,当一个订阅行为被 dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了(取消的是订阅，而不是终结observable)\n4、DisposeBag会在自己快要 dealloc 的时候，对它里面的所有订阅行为都调用 dispose() 方法\n\n")
        note.append(contentsOf: "观察者（observer）的创建方式：subscribe方法或bind方法\n\n")
        note.append(contentsOf: "Observable要预先将要发出的数据都准备好，等到有人订阅它时再将数据通过 Event 发出去;\nSubjects在运行时能动态地“获得”或者说“产生”出一个新的数据，再通过 Event 发送出去\n\n")
        note.append(contentsOf: "take和skip是一组互斥的操作\n\n")
        
    }
}


//MARK: Tools
///Disposable工厂
class AnyDisposable: Disposable {
    let _dispose: () -> Void
    
    init(_ disposable: Disposable) {
        _dispose = disposable.dispose
    }
    
    func dispose() {
        _dispose()
    }
}

///自定义error
enum MyError: Error {
    case A
    case B
    case C
}

///与数据相关的错误类型
enum DataError: Error {
    case cantParseJSON
}

///与缓存相关的错误类型
enum CacheError: Error {
    case failedCaching
}

///使用binder自定义可观察属性
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { view, size in
            view.font = UIFont.systemFont(ofSize: size)
        }
    }
}
extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(base) { view, size in
            view.font = UIFont.systemFont(ofSize: size)
        }
    }
}
