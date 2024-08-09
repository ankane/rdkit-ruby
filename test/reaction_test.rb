require_relative "test_helper"

class ReactionTest < Minitest::Test
  def test_from_smarts
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    assert_kind_of RDKit::Reaction, rxn
  end

  def test_from_smarts_invalid
    error = assert_raises(ArgumentError) do
      RDKit::Reaction.from_smarts("?")
    end
    assert_equal "invalid input", error.message
  end

  def test_to_svg
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    svg = rxn.to_svg
    assert_match "<svg", svg
    assert_match "width='250px'", svg
    assert_match "height='200px'", svg
  end

  def test_to_svg_width_height
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    svg = rxn.to_svg(width: 500, height: 400)
    assert_match "<svg", svg
    assert_match "width='500px'", svg
    assert_match "height='400px'", svg
  end

  def test_to_s
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    assert_equal "#<RDKit::Reaction [CH3:1][OH:2]>>[CH2:1]=[OH0:2]>", rxn.to_s
  end

  def test_inspect
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    assert_equal "#<RDKit::Reaction [CH3:1][OH:2]>>[CH2:1]=[OH0:2]>", rxn.inspect
  end

  def test_dup
    rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
    rxn.dup
  end
end
