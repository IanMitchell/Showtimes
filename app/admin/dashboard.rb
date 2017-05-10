ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Updates" do
          para "The Deschtimes Admin UI is still very much a work in progress, but poke around and see whaty you can do with it! I'm currently working on the following:"
          ul do
            li "Trim User Table, create new Fansubber Table (Name Pending)"
            li "Disable User Table Viewing / Editing"
            li "Allowing Data Editing (currently won't save)"
            li "Adding Model Validations"
            ul do
              li "Account"
              li "Alias"
              li "Channel"
              li "Episode"
              li "Fansub"
              li "Group"
              li "Member"
              li "Position"
              li "Release"
              li "Show"
              li "Staff"
              li "Station"
              li "User"
            end
            li "Fansub permission scoping (DDY can't edit GJM)"
            li "User account permissions (Only Admins+ can access)"
            li "New Fansub Form UI"
          end
          para "As always, you can reach out to me if you have any questions / comments / suggestions!"
        end
      end

      column do
        panel "Info" do
          para "TODO: Welcome Message. What else would be useful here?"
        end
      end
    end
  end
  
end
