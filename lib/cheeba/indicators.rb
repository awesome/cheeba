module Cheeba
  module Indicators
    DOC_START   = '---'
    DOC_TERM    = '...'
    HASH        = ':'
    SYMBOL      = ':'
    ARRAY       = '-'
    COMMENT     = '#'
    LINE_END    = "\n"    
    SPACE       = "\s"
    INDENT      = 2
    
    def self.options
      { :doc_start  => DOC_START,
        :doc_term   => DOC_TERM,
        :hash       => HASH,
        :symbol     => SYMBOL,
        :array      => ARRAY,
        :comment    => COMMENT,
        :line_end   => LINE_END,
        :space      => SPACE,
        :indent     => INDENT }
    end
  end
end
