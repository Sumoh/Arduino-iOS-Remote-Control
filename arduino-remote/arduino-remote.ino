//#include <IRremote.h>
//#include <IRremoteInt.h>

#include <Dhcp.h>
#include <Dns.h>
#include <Ethernet.h>
#include <EthernetClient.h>
#include <EthernetServer.h>
#include <EthernetUdp.h>

#include <EthernetBonjour.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; 

byte recievedBytes[200];
byte *bytesPtr;

int count = 0;

EthernetServer server(2300);

enum PacketType {
  unknown,
  integer,
  str,
  byteArr,
  actionPacket
};

class Packet{
  public:
  PacketType type;
  byte *data;
  byte *currByte;

  public:
  Packet(byte* packetData);
  ~Packet();

  int decodeInteger();
  char* decodeString();
  byte* decodeByteArray();

  void decodeActionPacket();

  Packet decodePacket();
  PacketType getType();
  
};

void setup() {
  // put your setup code here, to run once:
  Ethernet.begin(mac);
  Serial.begin(9600);
  server.begin();
  
  Serial.println("Starting...");

  EthernetBonjour.begin("ArduinoRemote");
  EthernetBonjour.addServiceRecord("_arduinoremote._tcp", 2300, MDNSServiceTCP);
  
}

void loop() {
  // put your main code here, to run repeatedly:

  EthernetBonjour.run();


  EthernetClient client = server.available();
  if (client){
    Serial.println("Got Client");
    bytesPtr = recievedBytes;
    while (client.connected()){
      if (client.available()){
        
          *bytesPtr = client.read();
          Serial.print(*bytesPtr, HEX);
          Serial.print(" ");
          bytesPtr++;
          count++;

          if (count > 4 && *(bytesPtr-1) == 0xFF && *(bytesPtr-2) == 0xFF && *(bytesPtr-3) == 0xFF && *(bytesPtr-4) == 0xFF){
            Serial.println();
            Serial.println("Making Packet:");
            Packet* packet = new Packet(recievedBytes);
            packet->decodePacket();
            delete packet;
            bytesPtr = recievedBytes;
          }
        //byte c = client.read();
      }
    }
    delay(1);
    client.stop();
  }
}


Packet::Packet(byte* packetData){
  type = unknown;
  int size = *(packetData+1) + 1;
  Serial.print("Packet Size: ");
  Serial.println(size);
  data = (byte*)malloc(size);
  memcpy(data, packetData, size);
  
  currByte = data;
  currByte += 3;
}

Packet::~Packet(){
  delete data;
  data = NULL;
}

Packet Packet::decodePacket(){

  byte type = *currByte;
  currByte++;

  switch(type){
    default:
      Serial.println("Unknown Packet");
      break;
    case 0x01:
      Serial.println("Integer");
      break;
    case 0x0B:
      Serial.println("String: ");
      Serial.println(decodeString());
      break;
    case 0x15:
      Serial.println("Byte Array");
      break;
    case 0x1F:
      Serial.println("actionPacket");
  }

  return false;
}

byte* Packet::decodeByteArray(){
  //first 2 bytes are length
  int length = 0;
  memcpy(&length, currByte, 2);
  currByte += 2;

  byte *byteArr = (byte*)malloc(length);
  memcpy(byteArr, currByte, length);
  return byteArr;
}

char* Packet::decodeString(){
  //first 2 bytes are the length
  int length = 0;
  memcpy(&length, currByte, 2);
  currByte += 2;

  char *str = (char *)malloc(length + 1);
  //memset(str, 0x0A, length+1);
  memcpy(str, currByte, length);
  *(str + length) = 0x00;
  currByte += length;
  return str;
}

PacketType Packet::getType(){
  return type;
}

