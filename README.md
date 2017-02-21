# RRPN

[![Build Status](https://travis-ci.org/siman-man/rrpn.svg?branch=master)](https://travis-ci.org/siman-man/rrpn)

RRPN is Reverse Polish Notation calculator and converter, written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rrpn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rrpn

## Usage

Integer

```ruby
rpn = '1 + 2 + 3'.to_rpn
p rpn.queue #=> [1, 2, :+, 3, :+]
p rpn.calc  #=> 6
puts rpn    #=> 1 2 + 3 +
```

Float

```ruby
rpn = '(1.0 + 2.0) * 3'.to_rpn
p rpn.queue #=> [1.0, 2.0, :+, 3, :*]
p rpn.calc  #=> 9.0
puts rpn    #=> 1.0 2.0 + 3 *
```

Rational

```ruby
rpn = '1/2r + 1/3r'.to_rpn
p rpn.queue #=> [1, "2r", :/, 1, "3r", :/, :+]
p rpn.calc  #=> (5/6)
puts rpn    #=> 1 2r / 1 3r / +
```

Complex

```ruby
rpn = '(1+2i) + (3+3i)'.to_rpn
p rpn.queue #=> [1, (0+2i), :+, 3, (0+3i), :+, :+]
p rpn.calc  #=> (4+5i)
puts rpn    #=> 1 0+2i + 3 0+3i + +
```

Other

```ruby
rpn = '(1 << 3) + (16 >> 2)'.to_rpn
p rpn.queue #=> [1, 3, :<<, 16, 2, :>>, :+]
p rpn.calc  #=> 12
puts rpn    #=> 1 3 << 16 2 >> +
```

Calculation

```ruby
p RRPN.calc([3, 4, :*]) #=> 12
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/siman-man/rrpn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

