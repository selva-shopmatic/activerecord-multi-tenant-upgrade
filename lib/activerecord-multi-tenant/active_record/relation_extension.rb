module ActiveRecord
  # = Active Record Relation
  class Relation
    alias :multi_tenant_orig_initialize :initialize
    def initialize(*args, &block)
      multi_tenant_orig_initialize(*args, &block)
      @creating_tenant = MultiTenant.current_tenant_id
    end

    def get_effective_tenant_id
      @creating_tenant || MultiTenant.current_tenant_id
    end
  end
end