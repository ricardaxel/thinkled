import std.algorithm;
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
    brightness = brightness > 0 ? 0 : maxBrightness;
  }

  void incrementBrightness()
  {
    brightness = min(brightness + 1, maxBrightness);
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
    ledFile.writef("%d", brightness);
    ledFile.flush();
    ledFile.seek(0);
  }


  private:
    uint brightness;
    const int maxBrightness;
    File ledFile;
    enum ledFileName = "/sys/class/leds/tpacpi::lid_logo_dot/brightness";
}
