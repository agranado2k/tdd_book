require 'rspec'

class Dollar
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def times(mult)
    self.class.new(@amount * mult)
  end

  def equal?(dollar)
    return false if dollar.nil?

    @amount == dollar.amount
  end
end

describe Dollar do
  it 'multipli amount' do
    five = Dollar.new(5)

    expect(Dollar.new(10)).to be_equal(five.times(2))
    expect(Dollar.new(15)).to be_equal(five.times(3))
  end

  it '$5 should be equal $5' do
    five = Dollar.new(5)

    expect(five.equal?(Dollar.new(5))).to be_truthy
  end

  it '$5 should be different from $7' do
    five = Dollar.new(5)

    expect(five.equal?(Dollar.new(7))).to be_falsey
  end

  it '$5 should be different from nil' do
    five = Dollar.new(5)

    expect(five.equal?(nil)).to be_falsey
  end
end


## Test list
# $5 + 10 CHF = $10 if rate is 2:1
# done ==> $5 * 2 = $10
# done ==> Dorllar side effect (we've already done that returning a value in times method
# Money rounding?
# done ==> equal()
# done =>> equal nil
# equal object
# hasCode()
