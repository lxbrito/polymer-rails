module Sprockets
  class Asset
    def initialize(environment, logical_path, pathname)
      raise ArgumentError, "Asset logical path has no extension: #{logical_path}" if File.extname(logical_path) == ""
      raise ArgumentError, "File does not exists: #{pathname}" unless File.exist?(pathname)
      @root         = environment.root
      @logical_path = logical_path.to_s
      @pathname     = Pathname.new(pathname)
      @content_type = environment.content_type_of(pathname)
      # drop precision to 1 second, same pattern followed elsewhere
      @mtime        = Time.at(environment.stat(pathname).try(:mtime).to_i)
      @length       = environment.stat(pathname).try(:size)
      @digest       = environment.file_digest(pathname).hexdigest
    end
  end
end