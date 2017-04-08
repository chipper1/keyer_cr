require "./keyer/*"

module Keyer
  class Parser
    @collection : Array(String)
    @singles : Array(Single)?
    def initialize(params : String)
      @collection = params.split("&")
      parse?(params)
    end

    def [](key : String)
      self[key]? || raise KeyError.new "Missing Keyer::Parser key: #{key.inspect}\nFrom: #{collection}"
    end

    def []?(key : String)
      return nil unless singles
      singles.not_nil!.each do |single|
        return single[key] if single[key]? 
      end
      nil
    end

    private def parse?(params : String)
      return nil unless is_valid params
      @singles = collection.map do |kv|
        k,v = kv.split("=")
        Single.new(k, v)
      end
    end

    private def is_valid(params : String)
      # Validate each item has assignment operator for key value pairs
      collection.all? {|s| s["="]? } #&&
      # TODO: FIX REGEX CHECK!  Works in Ruby, not here.
      #  collection.all? {|s|
      #    # Regex to validate nested parameters
      #    s.match(/\w+(?:(?:\[\w+\])+)?/) == s.split("=").first
      #  }
    end
    private property collection
    private property singles

    class Single
      @root : Hash(String, Single) | Hash(String, String) | Nil
      def initialize(param : String, value : String)
        @root = parse_single(param, value)
      end

      def [](key : String)
        self[key]? || raise KeyError.new "Missing Keyer::Parser::Single key: #{key.inspect}"
      end

      def []?(key : String)
        @root.not_nil![key]? || begin
            k = @root.not_nil!.keys.first
            return @root.not_nil![k] if k =~ /\A#{key}\].*/
          end
      end

      def call
        @root
      end

      private def parse_single(param : String, value : String) : Hash(String, String) | Hash(String, Single)
        if param =~ /\[\w+\]/
          key, _, tail = partition(param)
          return {key => self.class.new(tail, value)} unless tail.empty?
          {key => value}
        else
          {param => value}
        end
      end

      private def partition(str : String)
        str.partition(/(?:\]\[?)|(?:\[)/)
      end
    end
  end
end
