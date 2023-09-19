import cli;
import input;
import input_event_d;
import keyboard;
import led;

import std.stdio;

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

