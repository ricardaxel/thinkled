import led;
import input;
import input_event_d;

import core.thread;

import std.array;
import std.algorithm;
import std.file;
import std.string;
import std.stdio;

enum DEVICES_FILENAME = "/proc/bus/input/devices";


/// get filename of keyboard event
/// (with the form '/dev/input/inputX')
string getKeyboardEventFileName()
{

  const string content = readText(DEVICES_FILENAME);
  const string[] devices = content.split("\n\n");
  

  string keyboardDevice;
  foreach(device; devices)
  {
    if(device.canFind("keyboard"))
    {
      keyboardDevice = device;
      break;
    }
  }

  string event;
  foreach(line; keyboardDevice.split("\n"))
  {
    if(line[0] == 'H') // handler
      event = line.strip.split(" ")[$ - 1];
  }


  assert(event[0 .. 5] == "event");
  return "/dev/input/" ~ event;
}

int main()
{
  const string kbdEventFilename = getKeyboardEventFileName(); 
  File kdbEventFile = File(kbdEventFilename, "r");

  auto led = new Led(255);  
  
   
  foreach(ubyte[input_event.sizeof] buffer; kdbEventFile.byChunk(input_event.sizeof))
  {
    InputEvent event = InputEvent.fromRawBytes(buffer);
    if(event.isKeyEvent())
    {
      if(event.isKeyRelease())
        led.switchOff();
      else if(event.isKeyPress())
        led.switchOn();

    }
    led.update();
  }

  return 0;
}

