//
//  MQTTConnection.swift
//  circular
//
//  Created by Vitor Nunes on 02/01/18.
//  Copyright © 2018 Jose Soares. All rights reserved.
//

import Foundation
import CocoaMQTT

class MQTTConnection: CocoaMQTTDelegate {

    let mQTTHost = "iot.eclipse.org"
    var topic = "/ufpa/circular/loc/+"
    let mQTTPort : UInt16 = 1883

    var mqtt : CocoaMQTT?
    var onReceive : ((Int, Double, Double) -> ())?

    init() {

        let clientID = "CocoaMQTT" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host:mQTTHost , port: mQTTPort )
        //        mqtt!.username = ""
        //        mqtt!.password = ""
        mqtt!.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt!.keepAlive = 60
    }

    func connect(){
        print("Connecting to MQTT")
        mqtt!.delegate = self
        mqtt!.connect()
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        if ack == .accept {
            mqtt.subscribe(topic)
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string ?? "")")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        var messageArrary =  [String.SubSequence]()
        let topicId = message.topic.split(separator: "/")[3]
        if let messageText = message.string{
            messageArrary = messageText.split(separator: ",")
            if let receiveFunction = onReceive,
                let id = Int(topicId),
                let latitude = Double(messageArrary[3]),
                let longitude = Double(messageArrary[4]){
                receiveFunction(id, latitude, longitude)
            }
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        _console("mqttDidDisconnect with error")
        print(err)
    }
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }

}
