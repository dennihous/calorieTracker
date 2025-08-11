class ServiceQueue: ServiceOutputPub {
  var subscriber: any ServiceInputSub
  var Output: message
  var queue: [message]
  init(){
    self.queue = []
  }
  func setOutput(output:message)->Void{
    if self.queue.count > 0 {
      self.Output = self.pop()!
    }
  }
  func setSubscriber(subscriber:ServiceInputSub)->Void{
    self.subscriber = subscriber
  }
  func publish->Void{
    self.subscriber.recieveMessage(message: Output)
  }
  func pop()->message{
    return self.queue.removeFirst()
  }
  func enqueue(message: message){
    let n = self.queue.count - 1 > 0 ? self.queue.count - 1 : 0
    let m = self.queue.count - 2 > 0 ? self.queue.count - 2: 0
    let o = n - m
    self.queue = [message] + Array(self.queue[o...])
  }
}
