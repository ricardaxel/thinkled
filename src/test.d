import led;
import input;

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
   
/*   /1* foreach(ubyte[] buffer; kdbEventFile.byChunk(input_event.sizeof / ubyte.sizeof)) *1/ */
/*   foreach(ubyte[] buffer; kdbEventFile.byChunk(24)) */
/*   { */
/*     writeln(buffer); */
/*     event = cast(input_event*) buffer; */
/*     if(event.type == EV_KEY) */
/*       writefln("%d", event.value); */
/*   } */


  while(1)
  {
    led.toggle();
    led.update();
    Thread.sleep( dur!("msecs")( 50 ) ); // sleep for 5 seconds
  }
  
  /* input_event* event; */
  

  /* while(1) */
  /* { */
  /*   event = cast(input_event*) read(kbdEventFilename, input_event.sizeof); */
  /*   read(kbdEventFilename, input_event.sizeof * 3); */

  /*   // TODO shall be EV_KEY */
  /*   if(event.type == EV_MSC) */
  /*   { */
  /*     led.toggle(); */
  /*     led.update(); */
  /*   } */
  /* } */



  return 0;
}
