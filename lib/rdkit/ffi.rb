module RDKit
  module FFI
    extend Fiddle::Importer

    libs = Array(RDKit.ffi_lib).dup
    begin
      dlload Fiddle.dlopen(libs.shift)
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e
    end

    # https://github.com/rdkit/rdkit/blob/master/Code/MinimalLib/cffiwrapper.h

    # I/O
    extern "char *get_mol(const char *input, size_t *mol_sz, const char *details_json)"
    extern "char *get_qmol(const char *input, size_t *mol_sz, const char *details_json)"
    extern "char *get_molblock(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_v3kmolblock(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_smiles(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_smarts(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_cxsmiles(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_cxsmarts(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_json(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_rxn(const char *input, size_t *mol_sz, const char *details_json)"
    extern "char **get_mol_frags(const char *pkl, size_t pkl_sz, size_t **frags_pkl_sz_array, size_t *num_frags, const char *details_json, char **mappings_json)"

    # substructure
    extern "char *get_substruct_match(const char *mol_pkl, size_t mol_pkl_sz, const char *query_pkl, size_t query_pkl_sz, const char *options_json)"
    extern "char *get_substruct_matches(const char *mol_pkl, size_t mol_pkl_sz, const char *query_pkl, size_t query_pkl_sz, const char *options_json)"

    # drawing
    extern "char *get_svg(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_rxn_svg(const char *pkl, size_t pkl_sz, const char *details_json)"

    # calculators
    extern "char *get_descriptors(const char *pkl, size_t pkl_sz)"
    extern "char *get_morgan_fp(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_morgan_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes, const char *details_json)"
    extern "char *get_rdkit_fp(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_rdkit_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes, const char *details_json)"
    extern "char *get_pattern_fp(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_pattern_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes, const char *details_json)"
    extern "char *get_topological_torsion_fp(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_topological_torsion_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes, const char *details_json)"
    extern "char *get_atom_pair_fp(const char *pkl, size_t pkl_sz, const char *details_json)"
    extern "char *get_atom_pair_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes, const char *details_json)"
    extern "char *get_maccs_fp(const char *pkl, size_t pkl_sz)"
    extern "char *get_maccs_fp_as_bytes(const char *pkl, size_t pkl_sz, size_t *nbytes)"

    # modification
    extern "short add_hs(char **pkl, size_t *pkl_sz)"
    extern "short remove_all_hs(char **pkl, size_t *pkl_sz)"

    # standardization
    extern "short cleanup(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short normalize(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short neutralize(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short reionize(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short canonical_tautomer(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short charge_parent(char **pkl, size_t *pkl_sz, const char *details_json)"
    extern "short fragment_parent(char **pkl, size_t *pkl_sz, const char *details_json)"

    # coordinates
    extern "void prefer_coordgen(short val)"
    extern "short has_coords(char *mol_pkl, size_t mol_pkl_sz)"
    extern "short set_2d_coords(char **pkl, size_t *pkl_sz)"
    extern "short set_3d_coords(char **pkl, size_t *pkl_sz, const char *params_json)"
    extern "short set_2d_coords_aligned(char **pkl, size_t *pkl_sz, const char *template_pkl, size_t template_sz, const char *details_json, char **match_json)"

    # housekeeping
    # treat as void *ptr since calls free() internally
    FREE = extern "void free_ptr(char *ptr)"

    # other
    extern "char *version()"
    extern "void enable_logging()"
    extern "void disable_logging()"

    # chirality
    extern "short use_legacy_stereo_perception(short value)"
    extern "short allow_non_tetrahedral_chirality(short value)"

    # logging
    extern "void *set_log_tee(const char *log_name)"
    extern "void *set_log_capture(const char *log_name)"
    extern "short destroy_log_handle(void **log_handle)"
    extern "char *get_log_buffer(void *log_handle)"
    extern "short clear_log_buffer(void *log_handle)"
  end
end
