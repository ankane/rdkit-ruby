module RDKit
  module Utils
    def self.read_size(ptr)
      # TODO read as size_t
      ptr.ptr.to_i
    end
  end
end
