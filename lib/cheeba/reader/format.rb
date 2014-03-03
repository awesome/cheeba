module Cheeba
  module Reader
    module Format
      #
      # format datatypes in the parsed hash
      #
      def self.format(phs)
        self.adjust_options(phs)
        self.stripper(phs)
        self.key_to_int(phs)
        self.val_to_int(phs)
        self.key_to_sym(phs)
        self.val_to_sym(phs)
        self.key_to_true(phs)
        self.val_to_true(phs)
        phs
      end

      #
      # strips keys and values
      #
      def self.stripper(phs)
        psp = phs[:opt][:strip]
        psk = phs[:opt][:strip_keys]
        psv = phs[:opt][:strip_vals]
        phs[:key] = phs[:key].to_s.strip if psp or psk
        phs[:val] = phs[:val].to_s.strip if psp or psv
      end

      #
      # adjusts options
      #
      def self.adjust_options(phs)
        if phs[:opt][:auto_sym]
          phs[:opt][:auto_sym_keys] = true
          phs[:opt][:auto_sym_vals] = true
        end
      end

      #
      # true key
      #
      def self.key_to_true(phs)
        x = []
        x << phs[:opt][:auto_true].is_a?(TrueClass)
        x << phs[:opt][:auto_true_keys].is_a?(TrueClass)
        if x.any?
          case
          when (phs[:key].to_s.strip == "true"): phs[:key] = true
          when (phs[:key].to_s.strip == "false"): phs[:key] = false
          end
        end
      end

      #
      # true val
      #
      def self.val_to_true(phs)
        x = []
        x << phs[:opt][:auto_true].is_a?(TrueClass)
        x << phs[:opt][:auto_true_vals].is_a?(TrueClass)
        if x.any?
          case
          when (phs[:val].to_s.strip == "true"): phs[:val] = true
          when (phs[:val].to_s.strip == "false"): phs[:val] = false
          end
        end
      end

      #
      # symbolize key
      #
      def self.key_to_sym(phs)
        is_str = (phs[:key] =~ /^\d*$/).nil?
        x = []
        x << (phs[:opt][:sym_str] && is_str).is_a?(TrueClass)
        x << (phs[:opt][:sym_str_keys] && is_str).is_a?(TrueClass)
        x << phs[:opt][:symbolize].is_a?(TrueClass)
        x << (phs[:ask] && phs[:opt][:auto_sym_keys] && is_str).is_a?(TrueClass)
        x << phs[:opt][:symbolize_keys].is_a?(TrueClass)
        phs[:key] = phs[:key].to_s.to_sym if x.any?
      end

      #
      # symbolize val
      #
      def self.val_to_sym(phs)
        is_str = (phs[:val] =~ /^\d*$/).nil?
        x = []
        x << (phs[:opt][:sym_str] && is_str).is_a?(TrueClass)
        x << (phs[:opt][:sym_str_vals] && is_str).is_a?(TrueClass)
        x << phs[:opt][:symbolize].is_a?(TrueClass)
        x << (phs[:asv] && phs[:opt][:auto_sym_vals] && is_str).is_a?(TrueClass)
        x << phs[:opt][:symbolize_vals].is_a?(TrueClass)
        phs[:val] = phs[:val].to_s.to_sym if (x.any? && !phs[:val].to_s.strip.empty?)
      end

      #
      # key is parsed as string, so try to_i
      #
      def self.key_to_int(phs)
        x = []
        x << phs[:opt][:int].is_a?(TrueClass)
        x << phs[:opt][:int_keys].is_a?(TrueClass)
        phs[:key] = self.string_to_int(phs[:key]) if x.any?
      end

      #
      # val is parsed as string, so try to_i
      #
      def self.val_to_int(phs)
        x = []
        x << phs[:opt][:int].is_a?(TrueClass)
        x << phs[:opt][:int_vals].is_a?(TrueClass)
        phs[:val] = self.string_to_int(phs[:val]) if x.any?
      end

      #
      # returns int if string is convertable
      #
      def self.string_to_int(string)
        return string unless string.is_a?(String)
        string =~ /\A\d+\z/ ? string.to_i : string
      end
    end
  end
end
