require 'rrpn'

rpn = '1 + 2 + 3'.to_rpn
p rpn.queue #=> [1, 2, :+, 3, :+]
p rpn.calc  #=> 6

rpn = '(1.0 + 2.0) * 3'.to_rpn
p rpn.queue #=> [1.0, 2.0, :+, 3, :*]
p rpn.calc  #=> 9.0

rpn = '1/2r + 1/3r'.to_rpn
p rpn.queue #=> [1, "2r", :/, 1, "3r", :/, :+]
p rpn.calc  #=> (5/6)

rpn = '(1+2i) + (3+3i)'.to_rpn
p rpn.queue #=> [1, 3, :<<, 16, 2, :>>, :+]
p rpn.calc  #=> (4+5i)

rpn = '(1 << 3) + (16 >> 2)'.to_rpn
p rpn.queue #=> [1, (0+2i), :+, 3, (0+3i), :+, :+]
p rpn.calc  #=> 12

p RRPN.calc([3, 4, :*]) #=> 12