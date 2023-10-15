import std.array;
import std.algorithm;
import std.conv;
import std.exception;
import std.file;
import std.format;
import std.path;
import std.stdio;
import std.string;

import core.stdc.stdlib : exit;

int ledMaxBrightness(in DirEntry entry)
{
    auto maxBrightnessFile = buildPath(entry, "max_brightness");

    string content = std.file.readText(maxBrightnessFile);
    content = content.strip();

    return content.to!int;
}

class LedRegistry
{
    this()
    {
        this.leds = LedRegistry.getAvailableLeds();
    }

    void list()
    {
        writeln("Available leds :");
        writeln("----------------");
        writeln(this.leds.map!(led => led.toPrettyString()).join("\n"));
    }

    Led getLedByName(string name)
    {
        foreach (led; this.leds)
        {
            if (led.name == name)
                return led;
        }

        const errorMsg = format("Couldn't find led '%s'", name);
        throw new Exception(errorMsg);
    }

private:
    static Led[] getAvailableLeds()
    {
        Led[] leds;

        foreach (DirEntry entry; dirEntries(LEDS_BASE_DIRECTORY, SpanMode.shallow).filter!(
                e => e.isDir))
        {
            string ledName = baseName(entry.name);
            if (ledName.canFind("::"))
                ledName = ledName.split("::")[$ - 1];

            leds ~= Led(ledName, entry, ledMaxBrightness(entry));
        }

        return leds;
    }

    Led[] leds;

    // https://docs.kernel.org/leds/leds-class.html
    enum LEDS_BASE_DIRECTORY = "/sys/class/leds/";
}

struct Led
{
    const string name;
    const DirEntry directory;
    LedState state;
    int maxBrightness;

    this(in string name, in DirEntry directory, int maxBrightness)
    {
        this.name = name;
        this.maxBrightness = maxBrightness;
        this.state = LedState(buildPath(directory, "brightness"), maxBrightness);
    }

    string toPrettyString()
    {
        return format("%s (brightness %d/%d)", this.name,
                this.state.currentBrightness(), this.maxBrightness);
    }
}

struct LedState
{
    this(in string ledFileName, int maxBrightness)
    {
        try
        {
            ledFile = File(ledFileName, "w+");
        }
        catch (ErrnoException e)
        {
            stderr.writeln(e.msg);
            stderr.writeln("Hint: run this binary as sudo");

            exit(1);
        }
        this.maxBrightness = maxBrightness;
    }

    int currentBrightness()
    {
        ledFile.readf!"%d\n"(brightness);
        ledFile.flush();
        ledFile.seek(0);
        return brightness;
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
    const string ledFileName;
}
