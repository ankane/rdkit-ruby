module RDKit
  class Reaction
    private_class_method :new

    def self.from_smarts(input)
      rxn = allocate
      rxn.send(:load_rxn, input)
      rxn
    end

    def to_svg(width: 250, height: 200)
      details = {
        width: width,
        height: height
      }
      check_string(FFI.get_rxn_svg(@ptr, @sz, to_details(details)))
    end

    def to_s
      "#<#{self.class.name} #{@input}>"
    end
    alias_method :inspect, :to_s

    private

    def load_rxn(input)
      sz = Fiddle::Pointer.malloc(Fiddle::SIZEOF_SIZE_T, Fiddle::RUBY_FREE)
      @input = input.to_str
      ptr = FFI.get_rxn(+@input, sz, to_details({}))
      load_ptr(ptr, Utils.read_size(sz))
    end

    def load_ptr(ptr, sz)
      if ptr.null?
        raise ArgumentError, "invalid input"
      end

      @ptr = ptr
      @ptr.free = FFI["free_ptr"]
      @sz = sz
    end

    def to_details(options)
      JSON.generate(options)
    end

    def check_ptr(ptr)
      if ptr.null?
        raise Error, "bad pointer"
      end
    end

    def check_string(ptr)
      check_ptr(ptr)
      ptr.free = FFI["free_ptr"]
      ptr.to_s
    end
  end
end
