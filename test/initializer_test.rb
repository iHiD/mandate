require "test_helper"

class InitializerTest < Minitest::Test

  class BoringStorer
    include Mandate
    initialize_with
  end

  class ArgumentativeStorer
    include Mandate
    initialize_with :foo, :bar
  end

  class KeywordStorer
    include Mandate
    initialize_with :foo, bar: ["default"]
  end

  def test_initializes_properly_without_args
    BoringStorer.new
  end

  def test_initializes_properly_with_args
    foo = "fooooo"
    bar = "baaarrrr"
    storer = ArgumentativeStorer.new(foo, bar)
    assert_equal foo, storer.send(:foo)
    assert_equal bar, storer.send(:bar)
  end

  def test_initializes_properly_with_keyword_args
    foo = "fooooo"
    bar = "baaarrrr"
    storer = KeywordStorer.new(foo, bar: bar)
    assert_equal foo, storer.send(:foo)
    assert_equal bar, storer.send(:bar)
  end

  def test_initializes_properly_with_a_missing_keyword_arg
    foo = "fooooo"
    storer = KeywordStorer.new(foo)
    assert_equal foo, storer.send(:foo)
    assert_equal ["default"], storer.send(:bar)
  end

  def test_raises_with_wrong_amount_of_args
    assert_raises ArgumentError do
      ArgumentativeStorer.new(nil)
    end
  end

  def test_raises_with_wrong_keyword_args
    assert_raises ArgumentError do
      KeywordStorer.new("foo", qux: "bar")
    end
  end

  def test_vars_are_private
    assert_raises NoMethodError do
      ArgumentativeStorer.new(nil, nil).foo
    end
  end
end

