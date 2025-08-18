class BaseOutPutPub: ServiceOutPutPub{
    var subscriber: Optional<ServiceInputSub> = nil
    var Output: Optional<message> = nil
    init(){}
    func setOutput(output:message)->Void{
        self.Output=output
    }
    func setSubscriber(subscriber:ServiceInputSub)->Void{
        self.subscriber=subscriber
    }
    func publish()->Void{
        self.subscriber?.recieveMessage(message: self.Output!)
    }
}
