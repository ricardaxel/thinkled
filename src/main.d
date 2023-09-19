import cli;
import input;
import input_event_d;
import led;

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

int main(string[] argv)
{
  auto ledRegistry = new LedRegistry();

  auto args = parseArgv(argv);

  if(args.listLeds)
  {
    ledRegistry.list();
    return 0;
  }

  const string kbdEventFilename = getKeyboardEventFileName(); 
  File kdbEventFile = File(kbdEventFilename, "r");

  auto led = ledRegistry.getLedByName(args.led);
  
   
  foreach(ubyte[input_event.sizeof] buffer; kdbEventFile.byChunk(input_event.sizeof))
  {
    InputEvent event = InputEvent.fromRawBytes(buffer);
    if(event.isKeyEvent())
    {
      if(event.isKeyRelease())
        led.state.switchOff();
      else if(event.isKeyPress())
        led.state.switchOn();

    }
    led.state.update();
  }

  return 0;
}

