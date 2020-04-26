module SetSource
	extend ActiveSupport::Concern

  def set_source(source)
    session[:source] = source
  end
end