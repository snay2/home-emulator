#include <SPI.h>
#include <Button.h>
#include <LED.h>
#include <Ethernet.h>

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x6F, 0x0E };
byte ip[] = { 192,168,30,10 };
byte server[] = { 75,101,225,98 }; // webhooks.kynetxapps.net

Client client(server, 80);
Button button = Button(2, PULLUP);
LED redLed = LED(10);
LED yellowLed = LED(9);

void setup() {
  Ethernet.begin(mac, ip);
  Serial.begin(9600);
  redLed.off();
  yellowLed.on();
  delay(1000); // Give ethernet time to initialize

  Serial.println("Initialized. Waiting for button press.");
}

// TODO: Abstract this into a class
void ping() {
  // Connect if we're not already connected
  if (!client.connected()) {
    Serial.println("connecting...");
    client.connect();
  }
  
  // Proceed with the GET request
  if (client.connected()) {
    Serial.println("connected");
    client.println("GET /h/a163x133.dev/button1 HTTP/1.1");
    client.println("Host: webhooks.kynetxapps.net");
    client.println();
  } else {
    Serial.println("connection failed");
  }

  Serial.println("Made connection. Now waiting to read...");
  while (!client.available()) { /* wait for input */ }
  
  // Read the returned data
  while (client.available()) {
    char c = client.read();
    Serial.print(c);
  }
  Serial.println();
  Serial.println("Done reading.");
}

void loop() {
  // Every time the button is pressed, ping the webhook
  if (button.uniquePress()) {
    redLed.on();
    Serial.println("Button press event");
    ping();
    redLed.off();
  }
}
