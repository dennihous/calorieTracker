class SessionService: Service{
    var session: Session
    var currentView: String = ""
    var statePreCache: [Dictionary<String, Dictionary<String, Any>>] = []
    
    init(Entry: ServiceInputSub, Exit: ServiceOutputPub){
        self.session = Session(userID:"")
        super.init(proxyEntry: Entry, proxy: Exit)
        commands["loadCache"] = LoadCache(service: self)
        commands["updateSession"] = UpdateSession(service: self)
    }
    
    func initializeSession(message: message){
        var queryMessage = message
        queryMessage.meta["destination"] = "queryService"
        self.proxy.relayOut(message: queryMessage)
        let queryState = self.proxy.Entry.message
        let didMatch: Bool = queryState?.meta["found"] as! Bool
        if didMatch{
            let payloadDict = queryMessage.payload as! Dictionary<String, String>
            let userID: String = payloadDict["userID"]!
            var session: Session = Session(userID: userID)
            self.updateSession(session: session)
        }
    }
    
    func loadCache(message: message){
        if var payload = message.payload as? Dictionary<String, Dictionary<String, Any>> {
            if !statePreCache.isEmpty{
                var previousState = statePreCache.first!
                previousState.keys.filter { key in
                    !payload.keys.contains(key)
                }.forEach{key in
                    payload.updateValue(previousState[key]!, forKey: key)
                }
            }
        statePreCache.insert(payload, at: 0)
        if statePreCache.count > 10 {
            statePreCache.removeLast()
            }
        }
    }
    
    func updateSession(session: Session){
        var currentState = statePreCache.first!
        if session.foods == nil || session.foods!.isEmpty{
            session.foods = currentState
        }
        var sessionFoodEntries = session.foods!
        sessionFoodEntries.keys.filter({!currentState.keys.contains($0)}).forEach({key in
            currentState.updateValue(sessionFoodEntries[key]!, forKey: key)
        })
    }
    override func invokeCommnad(){
        let command = self.proxy.Entry.message!.command
        if self.commands.keys.contains(command){
            let commandInstance = self.commands[command]!
            let param: message = self.proxy.Entry.message!
            commandInstance.setParameter(parameter: param)
            self.proxy.relayOut(message: commandInstance.execute as! message)
        }else{
            var commandInstance = self.commands["loadCache"]
            commandInstance?.setParameter(parameter: self.proxy.Entry.message!)
            commandInstance?.execute()
            commandInstance = self.commands["updateSession"]
            commandInstance?.parameter = self.session
            commandInstance?.execute()
        }
    }
}
