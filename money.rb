require 'rspec'

class Dollar
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def times(mult)
    self.class.new(@amount * mult)
  end
end

describe Dollar do
  it 'multipli amount' do
    five = Dollar.new(5)

    ten = five.times(2)

    expect(ten.amount).to eq(10)
  end
end


## Test list
# $5 + 10 CHF = $10 if rate is 2:1
# done ==> $5 * 2 = $10
# done ==> Dorllar side effect (we've already done that returning a value in times method
# Money rounding?
