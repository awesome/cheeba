module Cheeba
  module Reader
    module Node
      #
      # hashpair
      #
      def self.hashpair(hsh, sym, spc)
        /^(#{spc}*)(\S*)#{hsh}#{spc}*(.*)#{spc}*$/
      end
      
      #
      # hashpair, both key and val are symbol
      #
      def self.hashpair_sym_all(hsh, sym, spc)
        /^(#{spc}*)(#{sym}\S*)#{hsh}#{spc}*(#{sym}.*)#{spc}*$/
      end
      
      #
      # hashpair, key is symbol
      #
      def self.hashpair_sym_key(hsh, sym, spc)
        /^(#{spc}*)(#{sym}\S*)#{hsh}#{spc}*(.*)#{spc}*$/
      end
      
      #
      # hashpair, value is symbol
      #
      def self.hashpair_sym_val(hsh, sym, spc)
        /^(#{spc}*)(\S*)#{hsh}#{spc}*(#{sym}.*)#{spc}*$/
      end

      #
      # hashkey is symbol
      #
      def self.hashkey_sym(hsh, sym, spc)
        /^(#{spc}*)(#{sym}\S*)#{hsh}#{spc}*$/ 
      end
      
      #
      # hashkey is awesome
      #
      def self.hashkey(hsh, spc)
        /^(#{spc}*)(\S*)#{hsh}#{spc}*$/ 
      end
      
      #
      # docstart and docterm
      #
      def self.document(idc, spc)
        /^#{spc}*#{idc}#{spc}*$/
      end
  
      #
      # comments and arrays
      #
      def self.left_match(idc, spc)
        /^(#{spc}*)#{idc}(#{spc}*)(.*)#{spc}*$/ 
      end
    end
  end
end
