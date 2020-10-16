class MakeMembersUniqueToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :admin, :boolean, default: false
    add_reference :members, :group, index: true, foreign_key: true

    # Create individual records
    GroupMember.all.each do |group_member|
      Member.create!(
        name: group_member.member.name,
        discord: group_member.member.discord,
        group: group_member.group,
        admin: group_member.admin
      )
    end

    # Drop relation table
    drop_table :group_members

    # Update all staff to point to new record
    Staff.all.each do |staff|
      staff.update_attribute :member, Member.find_by(
        discord: staff.member.discord,
        group: staff.release.fansub.groups
      )
    end

    # Drop all members without staff assignments
    Member.where.not(id: Staff.all).distinct.destroy_all

    # Drop all members without a group
    Member.where(group_id: nil).destroy_all
  end
end
