module Cheeba
  module Reader
    module Parser
      class IndentError < StandardError; end

      def self.parse(line, opts, num)
        results = self.parse_line(line, opts)
        phs = self.results_to_hash(results, opts)
        self.check_indent(line, phs[:spc], opts[:indent], num)
        phs 
      end

      ##
      # invalid number of spaces, line num and truncated line for context
      #
      def self.check_indent(line, spc, idt, num)
        raise IndentError, "#{num} #{line[1..50]}" if spc % idt != 0
      end
      
      ##
      # parses line, returns array, dependent on Node module
      #
      def self.parse_line(line, opts)
        chb = Cheeba::Reader::Node
        spc = opts[:space]
        hsh = opts[:hash]
        sym = opts[:symbol]
        dcs = opts[:doc_start]
        dct = opts[:doc_term]    
        arr = opts[:array]
        com = opts[:comment]

        case line
        when chb.left_match(arr, spc):             [:arr, Regexp.last_match.captures]
        when chb.left_match(com, spc):             [:com, Regexp.last_match.captures]
        when chb.hashkey_sym(hsh, sym, spc):       [:hky, Regexp.last_match.captures, nil, true]
        when chb.hashkey(hsh, spc):                [:hky, Regexp.last_match.captures]
        when chb.hashpair_sym_all(hsh, sym, spc):  [:hpr, Regexp.last_match.captures, true, true]
        when chb.hashpair_sym_key(hsh, sym, spc):  [:hpr, Regexp.last_match.captures, true]
        when chb.hashpair_sym_val(hsh, sym, spc):  [:hpr, Regexp.last_match.captures, nil, true]
        when chb.hashpair(hsh, sym, spc):          [:hpr, Regexp.last_match.captures]
        when /^\s*$/:                              [:bla]
        when chb.document(dcs, spc):               [:dcs]
        when chb.document(dct, spc):               [:dct]
        else;                                      [:mal, nil, nil, line]
        end
      end

      ##
      # creates hash with array vals, includes options
      #
      def self.results_to_hash(results, opt)
        msg, spc, key, val, ask, asv = results.flatten
        { :msg => msg, 
          :spc => (spc.nil? ? 0 : spc.length), 
          :key => key.to_s.sub(/^:/, ""),
          :val => val.to_s.sub(/^:/, ""),  
          :ask => ask, 
          :asv => asv, 
          :opt => opt} 
      end
    end
  end
end
