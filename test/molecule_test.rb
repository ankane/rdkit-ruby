require_relative "test_helper"

class MoleculeTest < Minitest::Test
  def test_from_smiles
    mol = RDKit::Molecule.from_smiles("CCO")
    assert_kind_of RDKit::Molecule, mol
    assert_equal "CCO", mol.to_smiles
  end

  def test_from_smiles_invalid
    error = assert_raises(ArgumentError) do
      RDKit::Molecule.from_smiles("?")
    end
    assert_equal "invalid input", error.message
  end

  def test_from_smarts
    mol = RDKit::Molecule.from_smarts("ccO")
    assert_kind_of RDKit::Molecule, mol
    assert_equal "ccO", mol.to_smarts
  end

  def test_from_smarts_invalid
    error = assert_raises(ArgumentError) do
      RDKit::Molecule.from_smarts("?")
    end
    assert_equal "invalid input", error.message
  end

  def test_num_atoms
    mol = RDKit::Molecule.from_smiles("CCO")
    assert_equal 3, mol.num_atoms

    mol = RDKit::Molecule.from_smiles("[H]OC([H])([H])C([H])([H])[H]", remove_hs: false)
    assert_equal 9, mol.num_atoms
  end

  def test_num_heavy_atoms
    mol = RDKit::Molecule.from_smiles("CCO")
    assert_equal 3, mol.num_heavy_atoms
  end

  def test_match
    mol = RDKit::Molecule.from_smiles("c1ccccc1O")
    pattern = RDKit::Molecule.from_smarts("ccO")
    assert_equal true, mol.match?(pattern)
    assert_equal [[0, 5, 6], [4, 5, 6]], mol.match(pattern)
  end

  def test_match_none
    mol = RDKit::Molecule.from_smiles("c1ccccc1O")
    pattern = RDKit::Molecule.from_smarts("ccOc")
    assert_equal false, mol.match?(pattern)
    assert_nil mol.match(pattern)
  end

  def test_match_from_smiles
    mol = RDKit::Molecule.from_smiles("C1=CC=CC=C1OC")
    assert_equal true, mol.match?(RDKit::Molecule.from_smiles("COC"))
    assert_equal false, mol.match?(RDKit::Molecule.from_smarts("COC"))
    assert_equal true, mol.match?(RDKit::Molecule.from_smarts("COc"))
  end

  def test_match_use_chirality
    mol = RDKit::Molecule.from_smiles("CC[C@H](F)Cl")
    assert_equal false, mol.match?(RDKit::Molecule.from_smiles("C[C@@H](F)Cl"), use_chirality: true)
  end

  def test_match_invalid_pattern
    mol = RDKit::Molecule.from_smiles("c1ccccc1O")
    error = assert_raises(ArgumentError) do
      mol.match("COC")
    end
    assert_equal "expected RDKit::Molecule", error.message
  end

  def test_fragments
    mol = RDKit::Molecule.from_smiles("n1ccccc1.CC(C)C.OCCCN")
    expected = ["c1ccncc1", "CC(C)C", "NCCCO"]
    assert_equal expected, mol.fragments.map(&:to_smiles)
  end

  def test_fragment_sanitize
    mol = RDKit::Molecule.from_smiles("N(C)(C)(C)C.c1ccc1", sanitize: false)
    expected = ["CN(C)(C)C", "c1ccc1"]
    assert_equal expected, mol.fragments(sanitize: false).map(&:to_smiles)
  end

  def test_rdkit_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 2048, mol.rdkit_fingerprint.length
  end

  def test_morgan_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 2048, mol.morgan_fingerprint.length
  end

  def test_morgan_fingerprint_length
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 1024, mol.morgan_fingerprint(length: 1024).length
  end

  def test_morgan_fingerprint_radius_zero
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    error = assert_raises(ArgumentError) do
      mol.morgan_fingerprint(radius: 0)
    end
    assert_equal "radius must be greater than 0", error.message
  end

  def test_pattern_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 2048, mol.pattern_fingerprint.length
  end

  def test_topological_torsion_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 2048, mol.topological_torsion_fingerprint.length
  end

  def test_atom_pair_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 2048, mol.atom_pair_fingerprint.length
  end

  def test_maccs_fingerprint
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal 166, mol.maccs_fingerprint.length
  end

  def test_add_hs
    mol = RDKit::Molecule.from_smiles("CCO")
    assert_equal "[H]OC([H])([H])C([H])([H])[H]", mol.add_hs.to_smiles
    assert_equal "CCO", mol.to_smiles
  end

  def test_add_hs!
    mol = RDKit::Molecule.from_smiles("CCO")
    mol.add_hs!
    assert_equal "[H]OC([H])([H])C([H])([H])[H]", mol.to_smiles
  end

  def test_remove_hs
    mol = RDKit::Molecule.from_smiles("[H]OC([H])([H])C([H])([H])[H]", remove_hs: false)
    assert_equal "CCO", mol.remove_hs.to_smiles
    assert_equal "[H]OC([H])([H])C([H])([H])[H]", mol.to_smiles
  end

  def test_remove_hs!
    mol = RDKit::Molecule.from_smiles("[H]OC([H])([H])C([H])([H])[H]", remove_hs: false)
    mol.remove_hs!
    assert_equal "CCO", mol.to_smiles
  end

  def test_cleanup
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    assert_equal "[CH2-]C[N+](=O)[O-].[Pt+]", mol.cleanup.to_smiles
    assert_equal "O=N(=O)CC[Pt]", mol.to_smiles
  end

  def test_cleanup!
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    mol.cleanup!
    assert_equal "[CH2-]C[N+](=O)[O-].[Pt+]", mol.to_smiles
  end

  def test_normalize
    mol = RDKit::Molecule.from_smiles("[CH2-]CN(=O)=O", sanitize: false)
    assert_equal "[CH2-]C[N+](=O)[O-]", mol.normalize.to_smiles
    assert_equal "[CH2-]CN(=O)=O", mol.to_smiles
  end

  def test_normalize!
    mol = RDKit::Molecule.from_smiles("[CH2-]CN(=O)=O", sanitize: false)
    mol.normalize!
    assert_equal "[CH2-]C[N+](=O)[O-]", mol.to_smiles
  end

  def test_neutralize
    mol = RDKit::Molecule.from_smiles("[CH2-]CN(=O)=O", sanitize: false)
    assert_equal "CCN(=O)=O", mol.neutralize.to_smiles
    assert_equal "[CH2-]CN(=O)=O", mol.to_smiles
  end

  def test_neutralize!
    mol = RDKit::Molecule.from_smiles("[CH2-]CN(=O)=O", sanitize: false)
    mol.neutralize!
    assert_equal "CCN(=O)=O", mol.to_smiles
  end

  def test_reionize
    mol = RDKit::Molecule.from_smiles("[O-]c1cc(C(=O)O)ccc1")
    assert_equal "O=C([O-])c1cccc(O)c1", mol.reionize.to_smiles
    assert_equal "O=C(O)c1cccc([O-])c1", mol.to_smiles
  end

  def test_reionize!
    mol = RDKit::Molecule.from_smiles("[O-]c1cc(C(=O)O)ccc1")
    mol.reionize!
    assert_equal "O=C([O-])c1cccc(O)c1", mol.to_smiles
  end

  def test_canonical_tautomer
    mol = RDKit::Molecule.from_smiles("OC(O)C(=N)CO")
    assert_equal "NC(CO)C(=O)O", mol.canonical_tautomer.to_smiles
    assert_equal "N=C(CO)C(O)O", mol.to_smiles
  end

  def test_canonical_tautomer!
    mol = RDKit::Molecule.from_smiles("OC(O)C(=N)CO")
    mol.canonical_tautomer!
    assert_equal "NC(CO)C(=O)O", mol.to_smiles
  end

  def test_charge_parent
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    assert_equal "CC[N+](=O)[O-]", mol.charge_parent.to_smiles
    assert_equal "O=N(=O)CC[Pt]", mol.to_smiles
  end

  def test_charge_parent!
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    mol.charge_parent!
    assert_equal "CC[N+](=O)[O-]", mol.to_smiles
  end

  def test_fragment_parent
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    assert_equal "[CH2-]C[N+](=O)[O-]", mol.fragment_parent.to_smiles
    assert_equal "O=N(=O)CC[Pt]", mol.to_smiles
  end

  def test_fragment_parent!
    mol = RDKit::Molecule.from_smiles("[Pt]CCN(=O)=O", sanitize: false)
    mol.fragment_parent!
    assert_equal "[CH2-]C[N+](=O)[O-]", mol.to_smiles
  end

  def test_to_smiles
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "Cc1ccccc1", mol.to_smiles
  end

  def test_to_smarts
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "[#6]-[#6]1:[#6]:[#6]:[#6]:[#6]:[#6]:1", mol.to_smarts
  end

  def test_to_cxsmiles
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "Cc1ccccc1", mol.to_cxsmiles
  end

  def test_to_cxsmarts
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "[#6]-[#6]1:[#6]:[#6]:[#6]:[#6]:[#6]:1", mol.to_cxsmarts
  end

  def test_to_json
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    data = JSON.parse(mol.to_json)
    assert_equal 11, data["rdkitjson"]["version"]
  end

  def test_to_svg
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    svg = mol.to_svg
    assert_match "<svg", svg
    assert_match "width='250px'", svg
    assert_match "height='200px'", svg
  end

  def test_to_svg_width_height
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    svg = mol.to_svg(width: 500, height: 400)
    assert_match "<svg", svg
    assert_match "width='500px'", svg
    assert_match "height='400px'", svg
  end

  def test_to_s
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "#<RDKit::Molecule Cc1ccccc1>", mol.to_s
  end

  def test_inspect
    mol = RDKit::Molecule.from_smiles("Cc1ccccc1")
    assert_equal "#<RDKit::Molecule Cc1ccccc1>", mol.inspect
  end
end
