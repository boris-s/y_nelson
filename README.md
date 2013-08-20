# YNelson

`YNelson` is a domain model and a simulator of _Nelson_ _nets_. A _Nelson_ _net_
is a Petri net, whose elements (places and transitions) have at the same time
the aspect of cells of the Zz structures described by Ted Nelson.

## Petri net aspect

`YNelson` provides a _domain_ _specific_ _language_ (DSL), that can be loaded by:
```ruby
  require 'y_nelson'
  include YNelson
```
`YNelson` DSL includes aspects of `YPetri`. It means, that it has the same
abilities as `YPetri`. See `YPetri` gem
[for Petri net aspect usage examples](https://github.com/boris-s/y_petri).

## Zz structure aspect

`YNelson` places and transtitions are both objects (or "cells", using Ted
Nelson's terminology) of a Zz structure. They exist in a multidimensional space,
where they can have at most 2 sides -- _posward_ and _negward_ -- in each
dimension. Zz structure aspect in general is defined in
[yzz gem](https://github.com/boris-s/y_petri). In addition to this, `YNelson`
automatically creates Zz connections in parallel to arcs of a Petri net. This
way, places and transtions of a Petri net, whose relations are normally captured
by arcs, can also have other relations defined, captured by Zz dimensions. Zz
structure aspect is still in alpha stage at present.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
