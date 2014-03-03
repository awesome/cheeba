module Cheeba
  module Writer
    module Builder
      def self.build(arr, inp, opt)
        spc = (opt[:space] * opt[:indent])
        case
        when inp.is_a?(Hash):   self.hash_to_array(arr, inp, opt, spc)
        when inp.is_a?(Array):  self.array_to_lines(arr, inp, opt, spc)
        when inp.is_a?(String): self.string_to_array(arr, inp, opt, spc)
        end
        arr
      end

      def self.sym_to_str(x, y = nil)
        a = x.is_a?(Symbol) ? x.inspect : x
        b = (!y.nil? && y.is_a?(Symbol)) ? y.inspect : y
        [a, b]
      end

      def self.string_to_array(arr, inp, opt, spc)
        self.array_to_lines(arr, inp.split(opt[:line_end]), opt, spc)
      end

      def self.hash_to_array(arr, inp, opt, spc)
        inp.each do |key,val|
          case
          when val.is_a?(Hash)
            key = self.sym_to_str(key)
            arr << opt[:doc_start] if opt[:docs]
            arr << "#{key}#{opt[:hash]}" unless opt[:docs]
            self.hash_to_lines(arr, val, val.keys, opt, spc, (opt[:docs] ? 0 : 1))
          when val.is_a?(Array)
            arr << opt[:doc_start] if opt[:docs]
            self.array_to_lines(arr, val, opt)
          else
            key, val = self.sym_to_str(key, val)
            arr << "#{key}#{opt[:hash]} #{val}"
          end
        end
      end

      #
      # line is array, push each indice to array, assumes every indice is a string
      #
      def self.array_to_lines(arr, val, opt, spc, idt = nil)
        idt = 0 if idt.nil?
        ist = spc * idt
        ind = opt[:array]
        until val.empty? do
          x = val.shift
          case
          when x.is_a?(Hash)
            arr << "#{ist}#{ind}"
            self.hash_to_lines(arr, x, x.keys, opt, spc, (idt + 1))
          when x.is_a?(Array)
            i = idt
            arr << "#{ist}#{ind}" if opt[:yaml]
            i += 1
            self.array_to_lines(arr, x, opt, spc, i)
          else
            x = self.sym_to_str(x)
            arr << "#{ist}#{ind} #{x}"
          end
        end
      end

      #
      # recursively add lines to array
      #
      def self.hash_to_lines(arr, hsh, kys, opt, spc, idt = nil)
        idt = 0 if idt.nil?
        while !kys.empty?
          ist = spc * idt
          key = kys.shift
          val = hsh[key]
          ind = opt[:hash]
          case
          when val.is_a?(Hash)
            # push key into lines_array
            arr << "#{ist}#{key}#{ind}"
            # step indent
            # call this again (the recursive part)
            self.hash_to_lines(arr, val, val.keys, opt, spc, (idt + 1))
          when val.is_a?(Array)
            arr << "#{ist}#{key}#{ind}"
            self.array_to_lines(arr, val, opt, spc, (idt + 1))
          else
            # if not Writer or Array, it must be String
            arr << "#{ist}#{key}#{ind} #{val}"
          end
        end
      end
    end
  end
end
