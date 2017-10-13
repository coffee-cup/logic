# logic

A little parser and interpreter to parse logical expressions

```
stack build
stack exec logic
```

```
logic> not false
True
logic> not false or true and (1 & 0) | !t
True
logic> not true
False
logic> !false
True
logic> !f
True
logic> 0 & 1
False
logic> 1 & (0 or 1)
True
```
