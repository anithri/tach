# tach
[tachyons.io](http://tachyons.io/) converted into Jetbrains live
templates

## usage
Copy some or all of the xml files in ```templates/``` to the
```<jetbrains ide dir>/config/templates``` and restart your IDE

Tested in RubyMine, PyCharm, and WebStorm

## example

### type
```
.showOff {
  .tc<tab>.pa3<tab>.f1<tab>.ma0<tab>
}
```

### result
```
.showOff {
  /* Tachyons - text-align: .tc */
  text-align: center;
  /* Tachyons - spacing: .pa3 */
  padding: var(--spacing-medium);
  /* Tachyons - type-scale: .f1 */
  font-size: var(--font-size-1);
  /* Tachyons - spacing: .ma0 */
  margin: var(--spacing-none);
}
```