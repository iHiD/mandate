require "test_helper"

class CallInjectorTest < Minitest::Test

  class Sumer
    include Mandate

    attr_reader :foo, :bar
    def initialize(foo, bar)
      @foo = foo
      @bar = bar
    end

    def call
      foo + bar
    end
  end

  class OneSumer
    include Mandate

    def initialize
    end

    def call
      1
    end
  end

  class KwargsSummer
    include Mandate

    attr_reader :a, :b
    def initialize(a, b:1)
      @a = a
      @b = b
    end

    def call
      a+b
    end
  end

  class SplatKwargsSummer
    include Mandate

    attr_reader :a, :b, :other
    def initialize(a, *other, b:1)
      @a = a
      @b = b
      @other = (other || [])
    end

    def call
      a+b+other.inject(:+).to_i
    end
  end

  class WeirdPrinter
    include Mandate

    attr_reader :a, :b
    def initialize(a, b)
      @a = a
      @b = b
    end

    def call
      "#{a} #{b.keys.join} #{b.values.join}"
    end
  end

  class BadConstant
    include Mandate

    def call
      IAmNotDefined
    end
  end

  def test_call_works_properly
    assert_equal 15, Sumer.(10, 5)
  end

  def test_call_works_properly_with_bad_constant
    assert_raises(NameError) do
      BadConstant.()
    end
  end

  def test_call_works_with_kwargs
    assert_equal 11, KwargsSummer.(10)
    assert_equal 15, KwargsSummer.(10, b: 5)
  end

  def test_call_works_with_splat_kwargs
    assert_equal 2, SplatKwargsSummer.(1)
    assert_equal 3, SplatKwargsSummer.(1, b: 2)
    assert_equal 15, SplatKwargsSummer.(1, 2, 4, b: 8)
  end

  def test_hash_as_final_param
    assert_equal "a b c", WeirdPrinter.("a", {b: "c"})
  end

  def test_empty_intitializer
    assert_equal 1, OneSumer.()
  end
end
