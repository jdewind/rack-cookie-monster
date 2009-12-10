module SpecInstanceHelpers
  def stub_instance_hash(*instance_names)
    hash = {}
    instance_names.each do |instance_name|
      hash[instance_name] = stub_instance(instance_name)
    end
    hash
  end

  def stub_string_hash(*instance_names)
    hash = {}
    instance_names.each do |instance_name|
      hash[instance_name] = stub_string(instance_name)
    end
    hash
  end
  
  def create_array_of_stubs(instance, count, stubbings)
    stub_array = stub_array_instance(instance, count, instance.to_s.singularize)
    stub_array.each do |stub|
      stubbings.each do |key, value_lambda|
        stub.stub!(key).and_return(value_lambda.call)
      end
    end
  end
  
  def stub_instance(var_name, options={})
    var_name = var_name.to_s.gsub(/[\?!]/, "")
    the_stub = stub(var_name.to_s.humanize, options)
    instance_variable_set("@#{var_name}", the_stub)
    the_stub
  end
  
  def stub_array_instance(ivar_sym, count, label=nil)
    label ||= ivar_sym.to_s.singularize
    array = stub_array(count, label)
    instance_variable_set("@#{ivar_sym}", array)
    array
  end
  
  def stub_array(count, label)
    array = []
    1.upto(count) do |i| 
      array << stub("#{label} #{i}")
    end
    array
  end

  def stub_instances(*var_names)
    var_names.map do |var_name|
      stub_instance var_name
    end
  end
  
  def stub_params(*param_names)
    @params = {}
    param_names.each do |param_name|
      instance_variable_set("@#{param_name}", "param #{param_name}")
      @params[param_name.to_s] = "param #{param_name}"
    end
    @params
  end

  def stub_partial(partial, options={})
    options = _prepare_stub_partial_options(partial, options)
    template.stub!(:render).with(options).and_return(%|<p id="#{partial.gsub(/\//,'_')}_partial"></p>|)
  end

  def stub_partials(*partials)
    partials.each &method(:stub_partial)
  end

  def stub_string(sym)
    the_stub = sym.to_s.humanize
    instance_variable_set("@#{sym}", the_stub)
    the_stub
  end

  def stub_strings(*syms)
    syms.each &method(:stub_string)
  end

  def stub_for_view(name, field_names)
    the_stub = stub_instance(name)
    _stub_methods_for_view(the_stub, field_names) 
    the_stub
  end
  
  

  def expect_and_render_partial(partial,options={})
    options = _prepare_stub_partial_options(partial, options)
    template.should_receive(:render).with(options).and_return(%|<p id="#{partial.gsub(/\//,'_')}_partial"></p>|)
  end

  def _stub_methods_for_view(the_stub, field_names) 
    field_names.each do |fname|
      case fname
      when String, Symbol
        field_name = fname.to_sym
        field_value = block_given?  ? yield(fname) : "The #{fname.to_s.humanize}"
        the_stub.stub!(field_name).and_return(field_value)
      when Hash
        fname.each do |k,v|
          the_stub.stub!(k.to_sym).and_return(v)
        end
      end
    end
  end
  
  def _prepare_stub_partial_options(partial, options)
    options.reverse_merge!(:partial => partial)
    if options[:locals] == false
      options.delete(:locals)
    else
      options.reverse_merge!(:locals => anything)
    end
    options
  end

  def stub_array_for_view(count, name_base, field_names)
    the_array = []
    count.times do |i|
      i = i + 1 # one-based numbering
      name = "#{name_base.to_s.singularize}#{i}"
      the_stub = stub_instance(name)
      _stub_methods_for_view(the_stub, field_names) do |fname|
        "The #{fname.to_s.humanize} #{i}"
      end
      the_array << the_stub
    end
    instance_variable_set("@#{name_base}", the_array)
    the_array
  end


end

class NilClass
  # Mocha:
  
  def expects(*args)
    raise "Don't expects(#{args.inspect}) on nil"
  end

  def stubs(*args)
    raise "Don't stubs(#{args.inspect}) on nil"
  end

  # RSpec mocks:
  #
  def stub!(*args)
    raise "Don't stub! on nil."
  end

  def should_receive(*args)
    raise "Don't should_receive on nil."
  end

  def should_not_receive(*args)
    raise "Don't should_not_receive on nil."
  end

end
