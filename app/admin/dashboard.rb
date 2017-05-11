ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: "Deschboard"

  content title: "Deschboard" do
    columns do
      column do
        panel "Recent Updates" do
          para "The Deschtimes Admin UI is still very much a work in progress, but poke around and see whaty you can do with it! I'm currently working on the following:"
          ul do
            li "Trim User Table, create new Fansubber Table (Name Pending)"
            li "Disable User Table Viewing / Editing"
            li "Adding Model Validations"
            ul do
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

      column do
        panel "Important Discord Note" do
          para "When adding Accounts or Channels, you'll use a user ID or server ID as the 'name' field value. To get these values, go into your Discord user settings and enable the developer options. You can then right click on users or servers and copy ID values easily."
        end
      end
    end
  end
end
