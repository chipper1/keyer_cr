# keyer

[![Build Status](https://travis-ci.org/danielpclark/keyer_cr.svg?branch=master)](https://travis-ci.org/danielpclark/keyer_cr)

Looking around I didn't see any Crystal library built to handle processing the parameter data for GET
and POST requests.  The existing system just hands you a string and lets you manually deal with all the joined
ampersands `&` and the nested form parameters.

This library lets you access the parameters with nested Hash-like behavior.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  keyer:
    github: danielpclark/keyer_cr
```

## Usage

```crystal
require "keyer"

v = Keyer::Parser.new("asdf=1234")
v["asdf"]?
# => "1234"
v["apple"]?
# => nil

v = Keyer::Parser.new("asdf[qwer]=1234")
v["asdf"]["qwer"]
# => "1234"

v = Keyer::Parser.new("a=7&asdf[qwer][poiu]=1234&cat=meow")
v["asdf"]["qwer"]["poiu"]
# => "1234"
v["a"]
# => "7"
v["cat"]
# => "meow"
```

With nested paramters you still need to take into account if one doesn't exist before going deeper.

## Contributing

1. Fork it ( https://github.com/danielpclark/keyer/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [danielpclark](https://github.com/danielpclark) Daniel P. Clark - creator, maintainer


## License

The MIT License (MIT)

Copyright (c) 2017 Daniel P. Clark and Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
