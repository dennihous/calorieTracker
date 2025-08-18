class Deserialize: baseWrapper{
    override func execute()->Optional<Any>{
        let message: message = self.parameter as! message
        return self.service.deserializeFEMessage(message)
    }
}
