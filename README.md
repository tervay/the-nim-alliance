## the_nim_alliance

Nim wrapper for TheBlueAlliance's v3 API.

Inspiration from [tbapy](https://github.com/frc1418/tbapy).

### Setup

```
nimble install the_nim_alliance
```

```nim
import the_nim_alliance
tba = TBA(authKey: "<my auth key>")
echo tba.team("frc2791")
```
