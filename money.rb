require 'rspec'

class Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def times(mult)
    self.class.new(amount * mult, currency)
  end

  def equal?(money)
    return false if money.nil?

    @amount == money.amount && currency == money.currency
  end

  def self.dollar(amount)
    Money.new(amount, 'USD')
  end

  def self.franc(amount)
    Money.new(amount, 'CHF')
  end

  def +(addend)
    Sum.new(self, addend)
  end

  def reduce(to_currency)
    self
  end
end

class Bank
  def reduce(exp, to_currency)
    exp.reduce(to_currency)
  end
end

class Sum
  attr_reader :augend, :addend

  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end

  def reduce(to_currency)
    Money.new(augend.amount + addend.amount, to_currency)
  end
end


describe Money do
  context 'currency' do
    it { expect(Money.dollar(5).currency()).to eq("USD") }
    it { expect(Money.franc(5).currency()).to eq("CHF") }
  end

  it 'multipli amount' do
    five = Money.franc(5)

    expect(Money.franc(10)).to be_equal(five.times(2))
    expect(Money.franc(15)).to be_equal(five.times(3))
  end

  context 'Franc is not Dollar' do
    it { expect(Money.franc(15)).to_not be_equal(Money.dollar(15)) }
  end

  context 'Addition' do
    it 'Sum is expression' do
      bank = Bank.new()
      five = Money.dollar(5)
      sum = five + five

      expect(sum.augend).to be_equal(five)
      expect(sum.addend).to be_equal(five)
    end

    it '$5 + $5 = $10' do
      skip
      five = Money.dollar(5)

      expect(Money.dollar(5) + five).to be_equal(Money.dollar(10))
    end

    it 'reduce expression' do
      bank = Bank.new()
      five = Money.dollar(5)
      sum = five + five
      reduced = bank.reduce(sum, 'USD')
      expect(reduced).to be_equal(Money.dollar(10))
    end

    it 'reduce Money' do
      bank = Bank.new()
      five = Money.dollar(5)
      reduced = bank.reduce(five, 'USD')
      expect(reduced).to be_equal(Money.dollar(5))
    end
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
# done ==> 5 CHF * 2 = 10 CHF
# done ==> Dollar/Franc duplication
# deno ==> Common equals
# done ==> Common times
# done ==> Compare Francs with Dollars
# done ==>  Currency?
# $5 + $5 = $10
# Return Money from  $5 + $5
# done ==> Bank.reduce(Money)
# Reduce Money with currency
# Reduce(Bank, string)
