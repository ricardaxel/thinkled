import std.conv;
import std.stdio;

class Led 
{
  this(int maxBrightness)
  {
    ledFile = File(ledFileName, "w));");
    this.maxBrightness = maxBrightness;
  }

  void toggle()
  {
    brightness = (brightness + 1) % (maxBrightness + 1);
  }

  void switchOn()
  {
    brightness = maxBrightness;
  }

  void switchOff()
  {
    brightness = 0;
  }

  void update()
  {
    writefln("writing .. %b", brightness);
    ledFile.writef("%d", brightness);
    ledFile.flush();
    ledFile.seek(0);
  }


  private:
    uint brightness;
    const int maxBrightness;
    File ledFile;
    /* enum ledFileName = "/sys/class/leds/tpacpi::kbd_backlight/brightness"; */
    enum ledFileName = "/sys/class/leds/tpacpi::power/brightness";
}
