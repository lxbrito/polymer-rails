module Sprockets
  # `Base` class for `Environment` and `Index`.
  class Base

    protected
    def build_asset(logical_path, pathname, options)
      pathname = Pathname.new(pathname)
      # If there are any processors to run on the pathname, use
      # `BundledAsset`. Otherwise use `StaticAsset` and treat is as binary.
      if attributes_for(pathname).processors.any?
        if options[:bundle] == false
          circular_call_protection(pathname.to_s) do
            ProcessedAsset.new(index, logical_path, pathname)
          end
        else
          BundledAsset.new(index, logical_path, pathname)
        end
      else
        StaticAsset.new(index, logical_path, pathname)
      end
    rescue Sprockets::ArgumentError => e
      logger.error("#{e.message} -- Ignoring file...")
      nil
    end
  end
end
