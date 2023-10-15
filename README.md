Compilation :

```
dmd  src/main.d src/led.d src/input_event_d.d src/cli.d src/keyboard.d src/input.c -of=thinkled
```

Usage :

```
thinkled --help

```

Format :

```
dub run dfmt -- --inplace --config . src/*.d
```
