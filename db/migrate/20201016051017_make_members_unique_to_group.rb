class MakeMembersUniqueToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :admin, :boolean, default: false
    add_reference :members, :group, index: true, foreign_key: true

    # Create individual records
    GroupMember.all.each do |group_member|
      Member.create(
        name: group_member.member.name,
        discord: group_member.member.discord,
        group: group_member.group,
        admin: group_member.admin
      )
    end

    destroyed_records = 0
    puts "Member Count: #{Member.count}"

    # Update all staff to point to new record
    Staff.all.each do |staff|
      if staff.release.nil?
        puts "Floating Staff member. Deleting."
        staff.destroy!
        destroyed_records += 1
        next
      end

      puts "Finding #{staff.release.fansub.name} #{staff.position.acronym}: #{staff.member.name}"

      if staff.release.fansub.groups.count == 0
        fansub = staff.release.fansub
        puts "\tCan not find group for #{fansub.name}. Destroying it."

        fansub.releases.each do |release|
          release.staff.each do |staff|
            staff.destroy!
            destroyed_records += 1
          end
          release.destroy!
          destroyed_records += 1
        end

        fansub.terms.each do |term|
          term.destroy!
          destroyed_records += 1
        end

        fansub.destroy!
        destroyed_records += 1
        next
      end


      member = Member.find_by(
        discord: staff.member.discord,
        group: staff.release.fansub.groups
      )
      if member.nil?
        puts "\tCAN NOT FIND MEMBER FOR:"
        puts "\t\tDiscord: #{staff.member.discord}"
        puts "\t\tGroup Count: #{staff.release.fansub.groups.count}"
        puts "\t\tName: #{staff.release.fansub.groups.first.name}"
        member = Member.create(
          discord: staff.member.discord,
          group: staff.release.fansub.groups.first,
          name: staff.member.name,
          admin: false
        )
      end

      staff.update(member: member)
    end

    # Drop all members without staff assignments
    puts "\n"
    puts "Removed #{destroyed_records} Floating Records"
    puts "Member Count: #{Member.count}"
    puts "Members not in Staff: #{Member.where.not(id: Staff.all).count}"

    GroupMember.all.each do |group_member|
      group_member&.member&.destroy!
    end

    # Drop relation table
    drop_table :group_members

    # Drop all members without a group or staff
    puts "Members without Groups: #{Member.where(group_id: nil).count}"
    Member.where(group_id: nil).destroy_all
  end
end
