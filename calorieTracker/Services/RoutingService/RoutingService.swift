class RoutingService: Service{
  var services: Dictionary<String, ServiceProxy> = [:]
  var serviceQueues: Dictionary<String, ServiceQueue> = [:]

  init(proxyEntry: ServiceInputSub, proxyExit: ServiceOutputPub, services: [Service]){
    super.init(proxyEntry: proxyEntry, proxyExit: proxyExit)
    for service in services{
      let serviceType = String(String(describing: type(of: service)).dropLast(7))
      self.services[serviceType] = service.proxy
      let queue: ServiceQueue = ServiceQueue()
      queue.subscriber = service.proxy.Entry
      self.serviceQueues[serviceType] = queue
    
    }
  }
  func link(output: ServiceOutPub, input: ServiceInputSub){
    output.setSubscriber(subscriber: input)
  }
  func makePipe(components: [String]){
    let proxies: Array<ServiceProxy> = components.map{ self.services[$0]! }
    let n = proxies.count - 1
    if n >= 0 {
        for i in 0..<n{
          link(output: proxies[i].Exit, input: proxies[i+1].Entry)
        }
      }
  }
  func route(message: message){
  let desiredService: String = message.meta["destination"]!
  if desiredService != ""{
    let serviceQueue = serviceQueues[desiredService]!
    serviceQueue.enqueue(message)
    }
  }
}
