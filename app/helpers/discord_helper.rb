module DiscordHelper
  def discord_update(webhook, name, status, color)
    embed = Discord::Embed.new do
      title name
      color color
      add_field name: 'Status',
                value: status
      footer text: DateTime.now.to_formatted_s(:long_ordinal)
    end

    Discord::Notifier.message embed, url: webhook
  end

  def discord_release(webhook, name, episode)
    embed = Discord::Embed.new do
      title name
      color 0x008000
      add_field name: 'Released!',
                value: "#{name} ##{episode} was released!"
      footer text: DateTime.now.to_formatted_s(:long_ordinal)
    end

    Discord::Notifier.message embed, url: webhook
  end
end
