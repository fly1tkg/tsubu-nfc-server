class User < ActiveRecord::Base
  attr_accessor :status
  has_many :nfcs
end
