## the_nim_alliance

Nim wrapper for [TheBlueAlliance](https://www.thebluealliance.com/)'s v3 API.

Inspiration from [tbapy](https://github.com/frc1418/tbapy).

### Setup

```
nimble install the_nim_alliance
```

`prog.nim`:
```nim
import the_nim_alliance
tba = TBA(authKey: "<my auth key>")
echo tba.team("frc2791")
```

You will need to compile with the `-d:ssl` flag.

```bash
nim c -d:ssl -r prog.nim
```
