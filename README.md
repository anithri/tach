# tach
[tachyons.io](http://tachyons.io/) converted into Jetbrains live
templates.

#### Uh, why?
I really like tachyons as a mnemonic devise, but prefer to write semantic
css.  This way I get a large chunk of tachyons design and class names,
but generate css properties instead of lists of classes.

#### Large chunks of?
I kept all selectors defined in the tachyons-custom package that
    a.  were classes,
    b.  were not @media dependent
    c.  did not use pseudo selectors

## usage
Inside a css rule, type the tachyons class name including a leading '.'

Tested in RubyMine, PyCharm, and WebStorm

### shortcuts
##### example
In a css file in your jetbrains IDE of choice.
```
.showOff {
  .tc<tab><tab>.pa3<tab><tab>.f1<tab><tab>.ma0<tab>
}

/* Result */

.showNoComments {
    text-align: center;
    padding: var(--spacing-medium);
    font-size: var(--font-size-1);
    margin: var(--spacing-none);
}
.showSideComments {
    text-align: center; /* .tc */
    padding: var(--spacing-medium); /* .pa3 */
    font-size: var(--font-size-1); /* .f1 */
    margin: var(--spacing-none); /* .ma0 */
}
.showTopComments {
    /* tachyons: .tc */
    text-align: center;
    /* tachyons: .pa3 */
    padding: var(--spacing-medium);
    /* tachyons: .f1 */
    font-size: var(--font-size-1);
    /* tachyons: .ma0 */
    margin: var(--spacing-none);
}
```
### Extras
Following the patterns in tachyons, the  ```tachyons-extra.xml``` file
contains a few extra templates

##### Media
A collection of templates to aid in making @media rules in the tachyons
patterns.
```@m```, ```@m.```, ```@m-ns```, ```@m-m```, ```@m-l```
```
/* @m<tab> */
@media (--breakpoint-not-small) {
}
@media (--breakpoint-medium) {
}
@medium (--breakpoint-large) {
}
/* @m.<tab>coolStuff */
.coolStuff {
}
@media (--breakpoint-not-small) {
    .coolStuff {
    }
}
@media (--breakpoint-medium) {
    .coolStuff {
    }
}
@media (--breakpoint-large) {
    .coolStuff {}
}
/* @m-ns */
@media (--breakpoint-not-small) {
}
/* @m-m */
@media (--breakpoint-medium) {
}
/* @m-l */
@media (--breakpoint-large) {
}
```

##### Skin
A template to quickly setup color themed classes
```
/* .skin<tab>saints-purple<tab>8D02B3 */

/* :root { --saints-purple: #8D02B3; } */
.saints-purple { color: var(--saints-purple); }
.bg-saints-purple { background-color: var(--saints-purple); }
.b--saints-purple { border-color: var(--saints-purple); }
.hover-saints-purple:hover,
.hover-saints-purple:focus { color: var(--saints-purple); }
```

## LICENSE
MIT with huge thanks to [tachyons.io](http://tachyons.io/)
