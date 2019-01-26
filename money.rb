require 'rspec'

class Money
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def times(mult)
    self.class.new(@amount * mult)
  end

  def equal?(money)
    return false if money.nil?

    @amount == money.amount
  end
end

class Dollar < Money
end

class Franc < Money
end

shared_examples 'Money' do
  it 'multipli amount' do
    five = described_class.new(5)

    expect(described_class.new(10)).to be_equal(five.times(2))
    expect(described_class.new(15)).to be_equal(five.times(3))
  end
end

describe Dollar do
  it_behaves_like 'Money'
end

describe Franc do
  it_behaves_like 'Money'
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
# done ==> 5 CHF * 2 = 10 CHF
# done ==> Dollar/Franc duplication
# deno ==> Common equals
# done ==> Common times
# Compare Francs with Dollars
