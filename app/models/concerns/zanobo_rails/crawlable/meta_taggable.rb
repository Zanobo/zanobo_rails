module ZanoboRails::Crawlable::MetaTaggable
  extend ActiveSupport::Concern

  included do

    # The controller and view metatag functions interface with the model through a hash of the above values
    # We provide this so that the internal mechanics of defining and retrieving custom and default meta values below
    # can be easily and completely overridden, when the required logic is simpler or significantly more complex
    def meta_tags_hash
      tag_hash = {}

      # Fetch non-blank custom tags
      meta_taggable_meta_tags.each do |tag|

        # Allow tags to be passed as hashes or objects
        # TODO - as of Ruby 2.0 just using the method accessors should work
        if tag.kind_of? Hash
          name = tag[:name]
          property = tag[:property]
        elsif tag.respond_to?(:name) && tag.respond_to?(:property)
          name = tag.name
          property = tag.property
        end

        # Remove blanks so we know what needs to be kept from defaults
        unless property.blank?
          tag_hash[name] = property
        end
      end

      # Check for default values for missing keys
      SIMPLE_CONTENT_META_TAGS.each do |name|
        unless tag_hash.has_key? name
          if (default = default_meta_tag(name))
            tag_hash[name] = default.property
          end
        end
      end

      tag_hash
    end

    private
    # We support a specialized set of content-related meta values
    # that provide a simple but powerful interface between objects and their final meta tags
    SIMPLE_CONTENT_META_TAGS = [
      :author,
      :authors,
      :description,
      :description_og,
      :description_twitter,
      :images,
      :keywords,
      :nofollow?,
      :noindex?,
      :page,
      :pages,
      :title,
      :title_og,
      :title_twitter,
      :type,
      :type_og,
      :type_twitter,
      :video,
    ]

    # Meta Taggable can retrieve object-level meta tag info to merge over its defaults
    # We expect to find a function called 'meta_tags', but we can look at any function

    # Look for #meta_tags by default
    def meta_taggable_meta_tags
      a = self.respond_to?(:meta_tags) ? meta_tags : []
    end

    # Tell us where to look
    def self.meta_tags_stored_as(sym)
      if sym.kind_of?(Symbol) && self.method_defined?(sym)
        alias_method :meta_taggable_meta_tags, sym
      end
    end


    # Set defaults
    # Takes some named functions and defines them on the model to use for default meta values
    # We do this, instead of just calculating them all outright, to save processing time
    # You could just define these functions in your model, but this is a nice way to group related snippets of logic,
    # if you don't need numerous lines for each
    #
    # Usage
    #   default_meta_tags description: -> { self.excerpt(Crawlable::Advisor.recommend(description: :max_chars) - 3) + '...'},
    #                     title: -> { self.title },
    #                     etc...
    # Results in
    #   def default_meta_description()
    #    self.excerpt(Crawlable.recommend(description: :max_chars) - 3) + '...'
    #   end
    #   def default_meta_description()
    #    self.title
    #   end
    #   etc...
    #
    def self.default_meta_tags(hash_of_procs)
      hash_of_procs.each do |name, proc|
        self.send(:define_method, :"default_meta_#{name.to_s}") do |*args|
          proc.call
        end
      end
    end

    # Get default
    # Call an individual default meta function by name
    def default_meta_tag(name)
      proc_name = "default_meta_#{name.to_s}"

      if self.respond_to? proc_name and not (property = self.send(proc_name)).blank?
        ZanoboRails::Crawlable::SimpleMetaTag.new(name, property)
      end
    end

  end
end
