namespace :data_migrations do
  # Corresponds with:
  # 20190308222032_consolidate_members.rb
  task :members  => :environment do |t, args|
    # Users have multiple members - consolidate to one
    User.all.each do |user|
      first = nil

      puts "Consolidating #{user.name}"
      user.members.each do |member|
        first ||= member
        first.groups << Group.find(member.group_id)
        member.delete unless first.eql? member
      end
    end

    # Accounts got merged into Member
    Member.all.each do |member|
      puts "Updating #{member.user.name}"
      member.name = member.user.name
      member.discord = member.user.accounts.where(platform: 1)&.first&.name
      member.save
    end

    # Staff need to point to a member now
    puts "Updating Staff..."
    Staff.all.each do |staff|
      staff.member = staff.user.members.first
      staff.save
    end

    puts "Done!"
  end
end
