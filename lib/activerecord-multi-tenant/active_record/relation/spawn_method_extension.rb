module ActiveRecord
  module SpawnMethods

    private

    

    def copy_attr_value(attr_name, result)
      if RequestStore.store[:disable_creating_tenant].nil? && result.send(attr_name) != self.send(attr_name) && klass.try(:scoped_by_tenant?)
        MultiTenant.warn_attribute_change(self, attr_name, result.send(attr_name), self.send(attr_name))
      end
      result.send("#{attr_name}=", self.send(attr_name))
    end

    def relation_with(values) # :nodoc:
      result = Relation.create(klass, table, values)
      # Shopmatic: attach @creating_tenant and @multi_tenant_disabled from original relation
      [:creating_tenant, :multi_tenant_disabled].each do |attr_name|
        if self.respond_to?(attr_name)
          copy_attr_value(attr_name, result)
        end
      end
      result.extend(*extending_values) if extending_values.any?
      result
    end
  end
end