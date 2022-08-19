require "test_helper"

class InitializerInjectorTest < Minitest::Test
  class BoringStorer
    include Mandate
    initialize_with
  end

  class ArgumentativeStorer
    include Mandate
    initialize_with :foo, :bar
  end

  class AttributesStorer
    include Mandate
    initialize_with :foo, :bar, :attributes
  end

  class KeywordStorer
    include Mandate
    initialize_with :foo, optional: "default", compulsary: Mandate::NO_DEFAULT
  end

  class BlockRunner
    include Mandate
    initialize_with :var do
      var.test_i_get_run
      other_method
    end

    def other_method
      var.test_i_also_get_run
    end
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

  def test_initializes_properly_with_attributes
    foo = "fooooo"
    bar = "baaarrrr"
    attrs = AttributesStorer.new(foo, bar, add: 1, to: 2)
    assert_equal ({ add: 1, to: 2 }), attrs.send(:attributes)
  end

  def test_initializes_properly_with_keyword_args
    foo = "fooooo"
    optional = mock
    compulsary = mock

    storer = KeywordStorer.new(foo, optional: optional, compulsary: compulsary)

    assert_equal foo, storer.send(:foo)
    assert_equal optional, storer.send(:optional)
    assert_equal compulsary, storer.send(:compulsary)
  end

  def test_initializes_properly_with_a_missing_optional_keyword_arg
    foo = "fooooo"
    compulsary = mock
    storer = KeywordStorer.new(foo, compulsary: compulsary)
    assert_equal foo, storer.send(:foo)
    assert_equal "default", storer.send(:optional)
  end

  def test_explodes_with_a_missing_compulsary_keyword_arg
    foo = "fooooo"

    assert_raises ArgumentError do
      KeywordStorer.new(foo)
    end
  end

  def test_initializes_with_a_block
    foo = mock
    foo.expects(:test_i_get_run).once
    foo.expects(:test_i_also_get_run).once

    BlockRunner.new(foo)
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
