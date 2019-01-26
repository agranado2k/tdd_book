require 'rspec'

class Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def times(mult)
    self.class.new(@amount * mult, @currency)
  end

  def equal?(money)
    return false if money.nil?

    @amount == money.amount && self.class == money.class
  end

  def self.dollar(amount)
    Dollar.new(amount, 'USD')
  end

  def self.franc(amount)
    Franc.new(amount, 'CHF')
  end
end

class Dollar < Money
end

class Franc < Money
end

describe Money do
  context 'currency' do
    it { expect(Money.dollar(5).currency()).to eq("USD") }
    it { expect(Money.franc(5).currency()).to eq("CHF") }
  end
end

describe Dollar do
  it 'multipli amount' do
    five = Money.dollar(5)

    expect(Money.dollar(10)).to be_equal(five.times(2))
    expect(Money.dollar(15)).to be_equal(five.times(3))
  end
end

describe Franc do
  it 'multipli amount' do
    five = Money.franc(5)

    expect(Money.franc(10)).to be_equal(five.times(2))
    expect(Money.franc(15)).to be_equal(five.times(3))
  end

  it { expect(Money.franc(15)).to_not be_equal(Money.dollar(15)) }
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
# done ==> Compare Francs with Dollars
# Currency?
