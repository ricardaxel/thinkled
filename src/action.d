public import std.concurrency : send, ownerTid;

public import led;

/// Interface that define possible actions on a led
shared interface ActionOnLed
{
    void action();
}
