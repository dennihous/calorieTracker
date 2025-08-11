protocol ServiceOutputPub{
  var subscriber: ServiceInputSub { get set }
  var Output: message { get set }
  func setOutput(output:message)->Void
  func setSubscriber(subscriber: ServiceInputSub)->Void
  func publish()->Void
}
