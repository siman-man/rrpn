require 'ripper'

class String
  def to_rpn
    RRPN.new(self)
  end
end

class RRPN
  attr_reader :queue

  def self.calc(queue)
    stack = []

    until queue.empty?
      stack << queue.shift

      if %i(+ - * / ** << >> % & ^ |).include?(stack.last)
        receiver, arg, op = stack.pop(3).map { |e| e.instance_of?(String) ? eval(e) : e }
        stack << receiver.send(op, arg)
      elsif %i(~ -@ +@).include?(stack.last)
        receiver, op = stack.pop(2).map { |e| e.instance_of?(String) ? eval(e) : e }
        stack << receiver.send(op)
      end
    end

    stack.pop
  end

  def initialize(formula)
    @formula = formula
    stree = Ripper.sexp(@formula)
    @queue = parse(stree[1..-1]).flatten
  end

  def parse(tree)
    queue = []

    case tree[0]
      when :paren
        queue << parse(tree[1..-1])
      when :binary
        return [parse(tree[1]), parse(tree[3]), tree[2]]
      when :unary
        return [parse(tree[2]), tree[1]]
      when :@int
        return tree[1].to_i
      when :@float
        return tree[1].to_f
      when :@rational
        return tree[1]
      when :@imaginary
        return tree[1]
      else
        if tree[0].instance_of?(Array)
          queue << parse(tree[0])
        else
          raise "Parse failed. '#{@formula}' - #{tree.inspect}"
        end
    end

    queue
  end

  def calc
    RRPN.calc(queue.dup)
  end

  def to_s
    queue.join(' ')
  end
end
