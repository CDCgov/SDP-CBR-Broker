require 'cgi'
module ApplicationHelper
  def deserialize_source_attributes(message)
    sa = message[:source_attributes]
    sa ? CGI.parse(sa) : {}
  end
end
