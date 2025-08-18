class Entry{
    static let entry: Entry = Entry()
    var uiAdapter: UIAdapterService
    var routing: RoutingService
    var session: SessionService
    private init(){
        var UIEntry = BaseInputSub()
        var UIExit = BaseOutputPub()
        self.uiAdapter = UIAdapterService(proxyEntry: UIEntry, proxyExit: UIExit)
        var sessionEntry = BaseInputSub()
        var sessionExit = BaseOutputPub()
        self.session = SessionService(Entry: sessionEntry, Exit: sessionExit)
        
        var services: [Service] = [self.uiAdapter, self.session]
        
        var routingEntry = BaseInputSub()
        var routingExit = BaseOutputPub()
        self.routing = RoutingService(proxyEntry: routingEntry, proxyExit: routingExit)
        let basePipe = ["UIAdapter", "Session"]
        self.routing.makePipe(components: basePipe)
    }
    public func ingest(message: message){
        self.uiAdapter.proxy.relayIn(message: message)
        self.uiAdapter.invokeCommand()
        self.session.invokeCommand()
    }
}
