module Cheeba
  module Defaults
    INT             = true
    INT_KEYS        = false
    INT_VALS        = false
    SYMBOLIZE       = false
    SYMBOLIZE_KEYS  = false
    SYMBOLIZE_VALS  = false
    AUTO_SYM        = true
    AUTO_SYM_KEYS   = false
    AUTO_SYM_VALS   = false
    AUTO_TRUE       = true
    AUTO_TRUE_KEYS  = false
    AUTO_TRUE_VALS  = false
    STRIP           = true
    STRIP_KEYS      = false
    STRIP_VALS      = false
    LIST            = false
    DOT             = true
    DOTFILE         = "#{ENV['HOME']}/.cheeba"
    YAML            = false
    DOCS            = false
    
    def self.descriptions
      { "auto_sym"       => "conv keys & vals: \":both\" => :both",
        "auto_sym_keys"  => "conv keys: \":key\" => :key",
        "auto_sym_vals"  => "conv vals: \":val\" => :val",
        "auto_true"      => "conv keys & vals: \"true\" => true",
        "auto_true_keys" => "conv keys: \"true\" => true",
        "auto_true_vals" => "conv vals: \"true\" => true",
        "docs"           => "doc separator first level hash nodes",
        "dot"            => "use dotfile if it exists",
        "int"            => "conv keys & vals: \"1\" => 1",
        "int_keys"       => "conv keys: \"1\" => 1",
        "int_vals"       => "conv vals: \"1\" => 1",
        "list"           => "return hash of address & comments",
        "strip"          => "strip keys & vals: \" both \" => \"both\"",
        "strip_keys"     => "strip keys: \" key \" => \"key\"",
        "strip_vals"     => "strip vals: \" val \" => \"val\"",
        "symbolize"      => "force conv keys & vals: \"both\" => :both",
        "symbolize_keys" => "force conv keys: \"key\" => :key",
        "symbolize_vals" => "force conv vals: \"val\" => :val",
        "yaml"           => "write files with YAML type array syntax"}
    end
    
    def self.options
      { :int            => INT,
        :int_keys       => INT_KEYS,
        :int_vals       => INT_VALS,
        :symbolize      => SYMBOLIZE, 
        :symbolize_keys => SYMBOLIZE_KEYS, 
        :symbolize_vals => SYMBOLIZE_VALS, 
        :auto_sym       => AUTO_SYM,
        :auto_sym_keys  => AUTO_SYM_KEYS,
        :auto_sym_vals  => AUTO_SYM_VALS,
        :auto_true      => AUTO_TRUE,
        :auto_true_keys => AUTO_TRUE_KEYS,
        :auto_true_vals => AUTO_TRUE_VALS,
        :strip          => STRIP,
        :strip_keys     => STRIP_KEYS,
        :strip_vals     => STRIP_VALS,
        :list           => LIST,
        :dot            => DOT,
        :dotfile        => DOTFILE,
        :yaml           => YAML,
        :docs           => DOCS}
    end
  end
end
