import core.thread;
import std.stdio;
import std.string;

import action;

// TODOs: 
// - handle spaces
// - sanitize entry (lowercase, throw clean error if unhandled character)

// https://morsecode.world/international/timing.html
enum timeUnit = dur!"msecs"(300);

shared class Morse : LedCallback
{
    string getName()
    {
      return "morse";
    }

    void action()
    {
      while(1)
      {
        send(ownerTid, LED_UPDATE.SWITCH_OFF);
        write("What do you wan't to see in morse : ");
        auto input = strip(stdin.readln());

        foreach(letter; input)
          displayLetter(letter);
      }
    }

  private:
    enum  Dit = 0;
    enum  Dah = 1;
    // https://morsedecoder.com/morse-code-alphabet/
    enum Alphabet = [
      [Dit, Dah], // a
      [Dah, Dit, Dit, Dit], // b
      [Dah, Dit, Dah, Dit], // c
      [Dah, Dit, Dit], // d
      [Dit], // e
      [Dit, Dit, Dah, Dit], // f
      [Dah, Dah, Dit], // g
      [Dit, Dit, Dit, Dit], // h
      [Dit, Dit], // i
      [Dit, Dah, Dah, Dah], // j
      [Dah, Dit, Dah], // k
      [Dit, Dah, Dit, Dah], // l
      [Dah, Dah], // m
      [Dah, Dit], // n
      [Dah, Dah, Dah], // o
      [Dit, Dah, Dah, Dit], // p
      [Dah, Dah, Dit, Dah], // q
      [Dit, Dah, Dit], // r
      [Dit, Dit, Dit], // s
      [Dah], // t
      [Dit, Dit, Dah], // u
      [Dit, Dit, Dit, Dah], // v
      [Dit, Dah, Dah], // w
      [Dah, Dit, Dit, Dah], // x
      [Dah, Dit, Dah, Dah], // y
      [Dah, Dah, Dit, Dit], // z
    ];

    void displayLetter(char letter)
    {
      const idx = letter - 'a';
      const morseCode = Alphabet[idx];

      foreach(unit; morseCode)
        displayUnit(unit);

      // Inter-character space: 3 units
      send(ownerTid, LED_UPDATE.SWITCH_OFF);
      Thread.sleep(3 * timeUnit);
    }

    void displayUnit(int unit)
    {
      final switch(unit) 
      {
      case Dit: // Dit: 1 unit
        send(ownerTid, LED_UPDATE.SWITCH_ON);
        Thread.sleep(1 * timeUnit);
        send(ownerTid, LED_UPDATE.SWITCH_OFF);
        break;
      case Dah: // Dah: 3 units
        send(ownerTid, LED_UPDATE.SWITCH_ON);
        Thread.sleep(3 * timeUnit);
        send(ownerTid, LED_UPDATE.SWITCH_OFF);
        break;
      }

      send(ownerTid, LED_UPDATE.SWITCH_OFF);
      // Intra-character space: 1 unit
      Thread.sleep(1 * timeUnit);
    }
}
