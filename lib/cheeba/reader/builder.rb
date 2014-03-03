module Cheeba
  module Reader
    module Builder
      #
      # Abbreviations:
      # adr = address
      # phs = parsed hash
      # hsh = hash
      # lst = list
      # met = meta
      # cur = current
      # spc = spaces
      # idt = indent
      # idx = index
      #
      # dcs = doc_start
      # dct = doc_term
      # hpr = hsh_pair
      # hky = hsh_key
      # arr = array
      # com = comment
      # mal = malformed
      # msg = message
      # bla = blank
      #
      class RootNodeError < StandardError; end

      ##
      # adds parsed_hash of line to hash
      #
      def self.build(hsh, phs)
        add = false
        upd = nil
        msg = phs[:msg]
        self.doc_new(hsh) if hsh.empty? && msg != "doc"
        val = phs[:val]
        lst = hsh[:lst]

        unless [:com, :mal, :bla].include?(msg)
          cur = self.cur(hsh)
          key = phs[:key]
          spc = phs[:spc]
          idt = phs[:opt][:indent]
          adr = hsh[:adr]
          idx = self.index(spc, idt)
          upd = self.update(adr, idx)
          las = self.adr_obj(hsh, hsh[:adr])
          add = true
        end

        case msg
        when :dcs: self.doc_start(hsh)
        when :dct: self.doc_term(hsh)
        when :hpr: self.hsh_pair(las, key, val)
        when :hky: self.hsh_key(las, adr, key)
        when :bla: self.blank(lst)
        when :arr
          raise RootNodeError if cur.is_a?(Hash) && !cur.empty? && spc == 0
          if las.is_a?(Hash) && las.empty?
            self.adr_obj_to_array(hsh, hsh[:adr])
            las = self.adr_obj(hsh, hsh[:adr])
          end
          self.arr_parse(las, adr, val, upd)
        when :com: self.comment(lst, val)
        when :mal: self.malformed(lst, val)
        end

        self.add_to_list(lst, adr) if add
      end

      ##
      # sub-parses array message, and logic from update-method
      #
      def self.arr_parse(las, adr, val, upd)
        case upd
        when "eq": self.array_val(las, val)
        when "lt": self.array_val(las, val)
        when "gt": self.array_new(las, adr, val)
        else; raise "error"
        end
      end

      ##
      # current hash, returns array of "doc"
      #
      def self.cur(hsh)
        hsh[hsh.length - 2]
      end

      ##
      # address array to string usable in eval on root node
      #
      def self.to_adr(adr)
        m = adr.map {|x|
          case
          when x.is_a?(Symbol): "[:#{x}]"
          when x.is_a?(String): "['#{x}']"
          when x.is_a?(Fixnum): "[#{x}]"
          end
        }
        m.to_s
      end

      ##
      # returns the actual object at an address in tree
      #
      def self.adr_obj(hsh, adr)
        m = self.to_adr(adr)
        eval("hsh#{m.to_s}")
      end

      ##
      # converts an object in tree to empty array
      #
      def self.adr_obj_to_array(hsh, adr)
        m = self.to_adr(adr)
        eval("hsh#{m.to_s} = []")
      end

      ##
      # calculates index based on spaces divided by indent unit
      #
      def self.index(spc, idt)
        ((spc % idt) != 0) ? 0 : spc / idt
      end

      # if indentation less than before, jump up tree, remove extra indices
      #
      def self.update(adr, idx)
        ret =  nil
        len = (adr.length - 1)
        if idx < len
          # remove indices after current index
          adr.replace(adr[0..idx])
          ret = "lt"
        elsif idx == len
          ret = "eq"
        elsif idx > len
          ret = "gt"
        end
        ret
      end

      ##
      # create keypair for new doc
      #
      def self.doc_new(hsh)
        hsh[:lst] ||= {}
        hsh[:adr] ||= []
        len = hsh.length - 1
        hsh[len] = {}
        hsh[:adr].clear
        hsh[:adr] << len
      end

      ##
      # new array in tree, provides logic for last modified object
      #
      def self.array_new(las, adr, val)
        case
        when las.is_a?(Array) && las.empty?
          x = [val]
          las = x
          adr << las.rindex(x)
        when las.is_a?(Array) && las.last.is_a?(String) && las.last.empty?
          x = [val]
          las[-1] = [val]
          adr << las.rindex(x)
        when las.is_a?(Array)
          x = [val]
          las << x
          adr << las.rindex(x)
        end
      end

      ##
      # start document
      #
      def self.doc_start(hsh)
        self.doc_new(hsh)
        self.add_to_list(hsh[:lst], "#DOC_START")
      end

      ##
      # document terminate
      #
      def self.doc_term(hsh)
        self.add_to_list(hsh[:lst], "#DOC_TERM")
      end

      ##
      # add val to array in tree
      #
      def self.array_val(las, val)
        case
        # when x is a hash, it's already addressed
        when las.is_a?(Array)
          las << val
        else
          raise las.inspect
        end
      end

      ##
      # add hashkey to tree
      #
      def self.hsh_key(las, adr, key)
        case
        when las.is_a?(Hash)
          las[key] = {}
        when las.is_a?(Array)
          x = {key => {}}
          las << x
          adr << las.rindex(x)
        end
        adr << key
      end

      ##
      # add hashpair to tree
      #
      def self.hsh_pair(las, key, val)
        case
        when las.is_a?(Array)
          x = {key => val}
          las << x
        when las.is_a?(Hash)
          las[key] = val
        end
      end

      ##
      # list stores hsh addresses of lines, comments, etc.
      #
      def self.add_to_list(lst, adr)
        case adr.class.to_s
        when "String": x = adr
        when "Array":  x = adr.join(",")
        end
        lst[lst.length + 1] = x
      end

      ##
      # add blank to list
      #
      def self.blank(lst)
        self.add_to_list(lst, "#BLANK")
      end

      ##
      # add comment to list
      #
      def self.comment(lst, val)
        lst[lst.length + 1] = "#COMMENT: #{val}"
      end

      ##
      # add malformed to list
      #
      def self.malformed(lst, val)
        lst[lst.length + 1] = "#MALFORMED: #{val}"
      end
    end
  end
end
