if defined?(ChefSpec)

  def converge_machine_batch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:machine_batch, :converge, resource_name)
  end

  def converge_machine(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:machine, :converge, resource_name)
  end
end