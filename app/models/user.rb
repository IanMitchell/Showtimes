class User < ApplicationRecord
  has_many :members
  has_many :staff
  has_many :accounts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  def group_admin?(group)
    self.members.where(
      group: group,
      role: [
        Member.roles[:admin],
        Member.roles[:founder]
     ]).present?
  end
end
