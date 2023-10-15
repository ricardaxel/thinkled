import std.getopt;
import core.stdc.stdlib : exit;

struct Args
{
    string led;
    bool listLeds;
}

Args parseArgv(string[] argv)
{
    bool needHelp = false;

    if (argv.length == 1)
        needHelp = true;

    Args args;
    auto opt = getopt(argv, "led|l", "name of led", &args.led, "list-leds",
            "list availabl leds", &args.listLeds);

    needHelp = needHelp || opt.helpWanted;

    if (needHelp)
    {
        defaultGetoptPrinter("thinkled usage:", opt.options);
        exit(0);
    }

    return args;
}
