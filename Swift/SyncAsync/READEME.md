# **동기**

코드상으로 동기(Sync)는 어떻게 실행이 되는지 알아보고자 한다.

## **코드 실행**

작성된 코드에서 **동기** 버튼을 클릭하면 우측에 타이머가 잠시 멈추었다가 이미지가 로드된 후에 동작하는 것을 확인할 수 있다.

![화면 기록 2022-11-06 오후 12 09 31](https://user-images.githubusercontent.com/69107255/200152166-7fed2987-4f89-4d75-9943-1d9b13587c24.gif)


<img width="915" alt="image" src="https://user-images.githubusercontent.com/69107255/200225399-fd15ed1b-ecb3-4740-a1a8-39e3e05baa3c.png">

```swift
@objc private func handleOnSyncButton() {
  // #1
  guard let url = URL(string: self.IMAGE_URL) else { return }
  // #2
  guard let data = try? Data(contentsOf: url) else { return }
  
  // #3
  let image = UIImage(data: data)
  // #4
  self.imageView.image = image
}
```

viewDidLoad함수가 실행되는 시점에 타이머가 반복하면서 1씩 증가 후 Label을 업데이트해 주는 코드가 동작하고 있다.

```swift
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      // #5
      self.counter += 1
      // #6
      self.countLabel.text = "\(self.counter)"
    }
```

## ② 비동기

```swift
  @objc private func handleOnAsyncButton() {
    DispatchQueue.global().async {
      guard let url = URL(string: self.IMAGE_URL) else { return }
      guard let data = try? Data(contentsOf: url) else { return }
      
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
  }
```