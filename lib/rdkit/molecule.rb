module RDKit
  class Molecule
    private_class_method :new

    def self.from_smiles(input, **options)
      mol = allocate
      mol.send(:load_smiles, input, **options)
      mol
    end

    def self.from_smarts(input)
      mol = allocate
      mol.send(:load_smarts, input)
      mol
    end

    def num_atoms(only_explicit: true)
      if only_explicit
        json_data["molecules"].sum { |v| v["atoms"].count }
      else
        descriptors["NumAtoms"].to_i
      end
    end

    def num_heavy_atoms
      descriptors["NumHeavyAtoms"].to_i
    end

    def match?(pattern, use_chirality: true)
      !match(pattern, use_chirality: use_chirality, max_matches: 1).nil?
    end

    def match(pattern, use_chirality: true, max_matches: nil)
      check_pattern(pattern)

      details = {
        useChirality: use_chirality
      }
      details[:maxMatches] = max_matches.to_i if max_matches
      json = check_string(FFI.get_substruct_matches(@ptr, @sz, pattern.instance_variable_get(:@ptr), pattern.instance_variable_get(:@sz), to_details(details)))

      matches = JSON.parse(json)
      if matches.any?
        matches.map { |v| v["atoms"] }
      end
    end

    def fragments(sanitize: true)
      sz_arr = Fiddle::Pointer.malloc(Fiddle::SIZEOF_VOIDP)
      num_frags = Fiddle::Pointer.malloc(Fiddle::SIZEOF_SIZE_T)
      details = {
        sanitizeFrags: sanitize
      }
      arr = FFI.get_mol_frags(@ptr, @sz, sz_arr.ref, num_frags.ref, to_details(details), nil)
      check_ptr(arr)

      num_frags.to_i.times.map do |i|
        ptr = (arr + i * Fiddle::SIZEOF_VOIDP).ptr
        sz = (sz_arr + i * Fiddle::SIZEOF_SIZE_T).ptr

        mol = self.class.allocate
        mol.send(:load_ptr, ptr, sz)
        mol
      end
    ensure
      free_ptr(sz_arr)
      free_ptr(arr)
    end

    def rdkit_fingerprint(min_path: 1, max_path: 7, length: 2048, bits_per_hash: 2, use_hs: true, branched_paths: true, use_bond_order: true)
      length = length.to_i
      check_length(length)

      details = {
        minPath: min_path.to_i,
        maxPath: max_path.to_i,
        nBits: length,
        nBitsPerHash: bits_per_hash.to_i,
        useHs: use_hs,
        branchedPaths: branched_paths,
        useBondOrder: use_bond_order
      }
      check_string(FFI.get_rdkit_fp(@ptr, @sz, to_details(details)))
    end

    def morgan_fingerprint(radius: 3, length: 2048, use_chirality: false, use_bond_types: true)
      radius = radius.to_i
      if radius < 1
        raise ArgumentError, "radius must be greater than 0"
      end

      length = length.to_i
      check_length(length)

      details = {
        radius: radius,
        nBits: length,
        useChirality: use_chirality,
        useBondTypes: use_bond_types
      }
      check_string(FFI.get_morgan_fp(@ptr, @sz, to_details(details)))
    end

    def pattern_fingerprint(length: 2048, tautomeric: false)
      length = length.to_i
      check_length(length)

      details = {
        nBits: length,
        tautomericFingerprint: tautomeric
      }
      check_string(FFI.get_pattern_fp(@ptr, @sz, to_details(details)))
    end

    def topological_torsion_fingerprint(length: 2048)
      length = length.to_i
      check_length(length)

      details = {
        nBits: length
      }
      check_string(FFI.get_topological_torsion_fp(@ptr, @sz, to_details(details)))
    end

    def atom_pair_fingerprint(length: 2048, min_length: 1, max_length: 30)
      length = length.to_i
      check_length(length)

      details = {
        nBits: length,
        minLength: min_length.to_i,
        maxLength: max_length.to_i
      }
      check_string(FFI.get_atom_pair_fp(@ptr, @sz, to_details(details)))
    end

    def maccs_fingerprint
      # remove bit 0 for correct length
      # https://github.com/rdkit/rdkit/issues/1726
      check_string(FFI.get_maccs_fp(@ptr, @sz))[1..]
    end

    def add_hs
      dup.add_hs!
    end

    def add_hs!
      check_status(FFI.add_hs(@ptr.ref, @sz.ref))
      self
    end

    def remove_hs
      dup.remove_hs!
    end

    def remove_hs!
      check_status(FFI.remove_all_hs(@ptr.ref, @sz.ref))
      self
    end

    def cleanup
      dup.cleanup!
    end

    def cleanup!
      check_status(FFI.cleanup(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def normalize
      dup.normalize!
    end

    def normalize!
      check_status(FFI.normalize(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def neutralize
      dup.neutralize!
    end

    def neutralize!
      check_status(FFI.neutralize(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def reionize
      dup.reionize!
    end

    def reionize!
      check_status(FFI.reionize(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def canonical_tautomer
      dup.canonical_tautomer!
    end

    def canonical_tautomer!
      check_status(FFI.canonical_tautomer(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def charge_parent
      dup.charge_parent!
    end

    def charge_parent!
      check_status(FFI.charge_parent(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def fragment_parent
      dup.fragment_parent!
    end

    def fragment_parent!
      check_status(FFI.fragment_parent(@ptr.ref, @sz.ref, to_details({})))
      self
    end

    def to_smiles
      check_string(FFI.get_smiles(@ptr, @sz, to_details({})))
    end

    def to_smarts
      check_string(FFI.get_smarts(@ptr, @sz, to_details({})))
    end

    def to_cxsmiles
      check_string(FFI.get_cxsmiles(@ptr, @sz, to_details({})))
    end

    def to_cxsmarts
      check_string(FFI.get_cxsmarts(@ptr, @sz, to_details({})))
    end

    def to_json
      check_string(FFI.get_json(@ptr, @sz, to_details({})))
    end

    def to_svg(width: 250, height: 200)
      details = {
        width: width,
        height: height
      }
      check_string(FFI.get_svg(@ptr, @sz, to_details(details)))
    end

    def to_s
      "#<#{self.class.name} #{to_smiles}>"
    end
    alias_method :inspect, :to_s

    private

    def initialize_copy(other)
      super
      load_smiles(other.to_smiles, sanitize: false, kekulize: false, remove_hs: false)
    end

    def load_smiles(input, sanitize: true, kekulize: true, remove_hs: true)
      sz = Fiddle::Pointer.malloc(Fiddle::SIZEOF_SIZE_T)
      details = {
        sanitize: sanitize,
        kekulize: kekulize,
        removeHs: remove_hs
      }
      ptr = FFI.get_mol(input.to_str, sz.ref, to_details(details))
      load_ptr(ptr, sz)
    end

    def load_smarts(input)
      sz = Fiddle::Pointer.malloc(Fiddle::SIZEOF_SIZE_T)
      ptr = FFI.get_qmol(input.to_str, sz.ref, to_details({}))
      load_ptr(ptr, sz)
    end

    def load_ptr(ptr, sz)
      if ptr.null?
        raise ArgumentError, "invalid input"
      end

      @ptr = ptr
      @ptr.free = FFI::FREE
      @sz = sz
    end

    def to_details(options)
      JSON.generate(options)
    end

    def json_data
      JSON.parse(to_json)
    end

    def descriptors
      JSON.parse(check_string(FFI.get_descriptors(@ptr, @sz)))
    end

    def check_pattern(pattern)
      unless pattern.is_a?(self.class)
        raise ArgumentError, "expected #{self.class.name}"
      end
    end

    def check_length(length)
      if length < 1
        raise ArgumentError, "length must be greater than 0"
      end
    end

    def check_ptr(ptr)
      if ptr.nil? || ptr.null?
        raise Error, "bad pointer"
      end
    end

    def free_ptr(ptr)
      FFI.free_ptr(ptr) if ptr
    end

    def check_string(ptr)
      check_ptr(ptr)
      begin
        ptr.to_s
      ensure
        free_ptr(ptr)
      end
    end

    def check_status(status)
      if status != 1
        raise Error, "bad status: #{status}"
      end
    end
  end
end
