#include <IRremote.h>
#include <IRremoteInt.h>

#include <Dhcp.h>
#include <Dns.h>
#include <Ethernet.h>
#include <EthernetClient.h>
#include <EthernetServer.h>
#include <EthernetUdp.h>

#include <EthernetBonjour.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; 

EthernetServer server(2300);

void setup() {
  // put your setup code here, to run once:
  Ethernet.begin(mac);
  Serial.begin(9600);
  server.begin();

  Serial.print("Starting...");

  EthernetBonjour.begin("ArduinoRemote");
  EthernetBonjour.addServiceRecord("_arduinoremote._tcp", 2300, MDNSServiceTCP);
  
}

void loop() {
  // put your main code here, to run repeatedly:

  EthernetBonjour.run();

  EthernetClient client = server.available();
  if (client.available()){

    char c = client.read();
    Serial.print(c);
  }

  if (!client.connected()){
    Serial.println("Disconnected....");
  }

  delay(1);

}
