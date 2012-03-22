class ActiveRecord::Base
  def self.per_page
    @@per_page ||= 50
  end

  def self.pagination(options)
    paginate :per_page => options[:per_page] || per_page, :page => options[:page]
  end
end
