module ActiveRecord
  # = Active Record Relation
  class Relation
    alias :multi_tenant_orig_initialize :initialize
    def initialize(*args, &block)
      multi_tenant_orig_initialize(*args, &block)
      @creating_tenant = MultiTenant.current_tenant_id
      @multi_tenant_disabled = MultiTenant.multi_tenant_disabled?
    end

    def multi_tenant_disabled?
      if !@multi_tenant_disabled.nil? && @multi_tenant_disabled != MultiTenant.multi_tenant_disabled?
        msg = <<-DOC
          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          
          WARNING: the relation #{self.class} statement is going to be loaded with different tenant 'multi_tenant_disabled' when creation!
          Creating 'multi_tenant_disabled': #{@multi_tenant_disabled}, loading value: #{MultiTenant.multi_tenant_disabled?}
          Automatically changed to value: #{@multi_tenant_disabled}

          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        DOC
        Rails.logger.warn msg
        STDERR.puts msg
      end
      @multi_tenant_disabled || MultiTenant.multi_tenant_disabled?
    end

    def get_effective_tenant_id
      if @creating_tenant && @creating_tenant != MultiTenant.current_tenant_id
        msg = <<-DOC
          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          
          WARNING: the relation #{self.class} statement is going to be loaded with different tenant id when creation!
          Creating tenant: #{@creating_tenant}, loading tenant: #{MultiTenant.current_tenant_id}
          Automatically changed to tenant: #{@creating_tenant}

          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        DOC
        Rails.logger.warn msg
        STDERR.puts msg
      end
      @creating_tenant || MultiTenant.current_tenant_id
    end
  end
end