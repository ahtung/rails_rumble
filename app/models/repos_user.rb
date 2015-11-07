class ReposUser < ActiveRecord::Base
  # Relations
  belongs_to :repo
  belongs_to :user
end
