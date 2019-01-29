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

  def reduce(bank, to_currency)
    rate = bank.rate(currency, to_currency)
    Money.new(amount / rate, to_currency)
  end
end

class Bank
  def initialize
    @rates = {}
  end

  def reduce(exp, to_currency)
    exp.reduce(self, to_currency)
  end

  def add_rate(from, to, rate)
    @rates["#{from}-#{to}"] = rate
  end

  def rate(from, to)
    return 1 if from == to
    @rates["#{from}-#{to}"]
  end
end

class Sum
  attr_reader :augend, :addend

  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end

  def reduce(bank, to)
    Money.new(augend.reduce(bank, to).amount + addend.reduce(bank, to).amount, to)
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

    it 'reduce Money with different currencies' do
      bank = Bank.new()
      bank.add_rate('CHF', 'USD', 2)
      money = Money.franc(2)
      reduced = bank.reduce(money, 'USD')
      expect(reduced).to be_equal(Money.dollar(1))
    end

    it 'Add with mixed currencies' do
      fiveBucks = Money.dollar(5)
      tenFrancs = Money.franc(10)
      bank = Bank.new
      bank.add_rate('CHF', 'USD', 2)

      result = bank.reduce(fiveBucks + tenFrancs, 'USD')

      expect(result).to be_equal(Money.dollar(10))
    end
  end
end

describe Bank do
  context 'Convert rates' do
    it 'Same currency for from and to' do
      bank = Bank.new
      expect(bank.rate('USD', 'USD')).to eq(1)
    end
  end
end

## Test list
# done ==> $5 + 10 CHF = $10 if rate is 2:1
# done ==> $5 * 2 = $10
# done ==> Dorllar side effect (we've already done that returning a value in times method
# done ==> equal()
# done =>> equal nil
# done ==> 5 CHF * 2 = 10 CHF
# done ==> Dollar/Franc duplication
# deno ==> Common equals
# done ==> Common times
# done ==> Compare Francs with Dollars
# done ==>  Currency?
# done ==> $5 + $5 = $10
# done ==> Bank.reduce(Money)
# done ==> Reduce Money with currency
# done ==> Reduce(Bank, string)
