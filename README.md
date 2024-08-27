# RDKit.rb

Cheminformatics for Ruby, powered by [RDKit](https://github.com/rdkit/rdkit)

[![Build Status](https://github.com/ankane/rdkit-ruby/actions/workflows/build.yml/badge.svg)](https://github.com/ankane/rdkit-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "rdkit-rb"
```

## Getting Started

Create a molecule

```ruby
mol = RDKit::Molecule.from_smiles("c1ccccc1O")
```

Get the number of atoms

```ruby
mol.num_atoms
```

Get substructure matches

```ruby
mol.match(RDKit::Molecule.from_smarts("ccO"))
```

Get fragments

```ruby
mol.fragments
```

Generate an SVG

```ruby
mol.to_svg
```

## Fingerprints

A number of [fingerprints](https://www.rdkit.org/docs/RDKit_Book.html#additional-information-about-the-fingerprints) are supported.

RDKit

```ruby
mol.rdkit_fingerprint
```

Morgan

```ruby
mol.morgan_fingerprint
```

Pattern

```ruby
mol.pattern_fingerprint
```

Atom pair

```ruby
mol.atom_pair_fingerprint
```

Topological torsion

```ruby
mol.topological_torsion_fingerprint
```

MACCS

```ruby
mol.maccs_fingerprint
```

You can use a library like [pgvector-ruby](https://github.com/pgvector/pgvector-ruby) to find similar molecules. See an [example](https://github.com/pgvector/pgvector-ruby/blob/master/examples/rdkit/example.rb).

## Updates

Add or remove hydrogen atoms

```ruby
mol.add_hs!
mol.remove_hs!
```

Standardize

```ruby
mol.cleanup!
mol.normalize!
mol.neutralize!
mol.reionize!
mol.canonical_tautomer!
mol.charge_parent!
mol.fragment_parent!
```

## Conversion

SMILES

```ruby
mol.to_smiles
```

SMARTS

```ruby
mol.to_smarts
```

CXSMILES

```ruby
mol.to_cxsmiles
```

CXSMARTS

```ruby
mol.to_cxsmarts
```

JSON

```ruby
mol.to_json
```

## Reactions

Create a reaction

```ruby
rxn = RDKit::Reaction.from_smarts("[CH3:1][OH:2]>>[CH2:1]=[OH0:2]")
```

Generate an SVG

```ruby
rxn.to_svg
```

## History

View the [changelog](https://github.com/ankane/rdkit-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/rdkit-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/rdkit-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/rdkit-ruby.git
cd rdkit-ruby
bundle install
bundle exec rake vendor:all
bundle exec rake test
```
