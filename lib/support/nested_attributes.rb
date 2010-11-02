module MongoMapper
  module NestedAttributes #:nodoc:

    #class TooManyDocuments < MongoMapperError
    #end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_inheritable_accessor :nested_attributes_options, :instance_writer => false
      base.nested_attributes_options = {}
    end

    module ClassMethods
      REJECT_ALL_BLANK_PROC = proc { |attributes| attributes.all? { |_, value| value.blank? } }

      def accepts_nested_attributes_for(*attr_names)
        options = { :allow_destroy => false, :update_only => false }
        options.update(attr_names.extract_options!)
        options.assert_valid_keys(:allow_destroy, :reject_if, :limit, :update_only)
        options[:reject_if] = REJECT_ALL_BLANK_PROC if options[:reject_if] == :all_blank

        attr_names.each do |association_name|
#          if reflection = reflect_on_association(association_name)
#            reflection.options[:autosave] = true
#            add_autosave_association_callbacks(reflection)
#            nested_attributes_options[association_name.to_sym] = options
#            type = (reflection.collection? ? :collection : :one_to_one)
          if associations.any? { |key, _| key == association_name.to_s }
            nested_attributes_options[association_name.to_sym] = options
            type = :collection            
            class_eval %{
              def #{association_name}_attributes=(attributes)
                assign_nested_attributes_for_#{type}_association(:#{association_name}, attributes)
              end
            }, __FILE__, __LINE__
          else
            raise ArgumentError, "No association found for name `#{association_name}'. Has it been defined yet?"
          end
        end
      end
    end
#    def _destroy
#      marked_for_destruction?
#    end

    private

    UNASSIGNABLE_KEYS = %w( id _id _destroy )

    def assign_nested_attributes_for_collection_association(association_name, attributes_collection)
      options = nested_attributes_options[association_name]

      unless attributes_collection.is_a?(Hash) || attributes_collection.is_a?(Array)
        raise ArgumentError, "Hash or Array expected, got #{attributes_collection.class.name} (#{attributes_collection.inspect})"
      end

      if options[:limit] && attributes_collection.size > options[:limit]
        raise TooManyDocuments, "Maximum #{options[:limit]} documents are allowed. Got #{attributes_collection.size} documents instead."
      end

#      p "START====================================================================================="
#      p association_name
#      p attributes_collection

      if attributes_collection.is_a? Hash
#        p "YES, A HASH"
        attributes_collection = attributes_collection.sort_by { |index, _| index.to_i }.map { |_, attributes| attributes }
      end

#      p "AFTER SORT"
#      p attributes_collection

#      p "END========================================================================================"

      attributes_collection.each do |attributes|
        p attributes
        attributes = attributes.with_indifferent_access

        if attributes['id'].blank?
          unless reject_new_record?(association_name, attributes)
            send(association_name).build(attributes.except(*UNASSIGNABLE_KEYS))
          end
        elsif existing_document = send(association_name).detect { |document| document.id.to_s == attributes['id'].to_s }
          assign_to_or_mark_for_destruction(association_name, existing_document, attributes, options[:allow_destroy])
        else
          raise_nested_attributes_document_not_found(association_name, attributes['id'])
        end
      end
    end

    def assign_to_or_mark_for_destruction(association_name, document, attributes, allow_destroy)
      if has_destroy_flag?(attributes) && allow_destroy
        send(association_name).delete_if {|q| q.id.to_s == document.id.to_s }
      else
        document.attributes = attributes.except(*UNASSIGNABLE_KEYS)
        #document.update_attributes(attributes.except(*UNASSIGNABLE_KEYS))
      end
    end

    def has_destroy_flag?(hash)
      Boolean.to_mongo(hash['_destroy'])
    end

    def reject_new_record?(association_name, attributes)
      has_destroy_flag?(attributes) || call_reject_if(association_name, attributes)
    end

    def call_reject_if(association_name, attributes)
      case callback = nested_attributes_options[association_name][:reject_if]
      when Symbol
        method(callback).arity == 0 ? send(callback) : send(callback, attributes)
      when Proc
        nested_keys = attributes.keys.select {|k| k.to_s =~ /attributes$/}
        callback.call(attributes.except(*nested_keys).except(*UNASSIGNABLE_KEYS))
      end
    end

    def raise_nested_attributes_document_not_found(association_name, document_id)
      raise DocumentNotFound, "Couldn't find #{association_name.classify} with ID=#{document_id} for #{self.class.name} with ID=#{id}"
     end
  end
end
