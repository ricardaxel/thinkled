import std.algorithm;
import std.array;
import std.file;
import std.string;

// https://unix.stackexchange.com/questions/74903/explain-ev-in-proc-bus-input-devices-data
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
