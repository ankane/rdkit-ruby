# stdlib
require "fiddle/import"
require "json"

# modules
require_relative "rdkit/molecule"
require_relative "rdkit/reaction"
require_relative "rdkit/version"

module RDKit
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_path =
    if Gem.win_platform?
      "x64-mingw/rdkitcffi.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        "arm64-darwin/librdkitcffi.dylib"
      else
        "x86_64-darwin/librdkitcffi.dylib"
      end
    else
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        "aarch64-linux/librdkitcffi.so"
      else
        "x86_64-linux/librdkitcffi.so"
      end
    end
  vendor_lib = File.expand_path("../vendor/#{lib_path}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "rdkit/ffi"

  def self.lib_version
    FFI.version.to_s
  end
end
