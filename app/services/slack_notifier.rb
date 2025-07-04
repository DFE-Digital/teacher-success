class SlackNotifier
  include HTTParty

  def initialize
    @webhook_url = ENV["SLACK_WEBHOOK_URL"]
  end

  def ping(text: nil, blocks: nil, username: "Notifier (#{Rails.env})", icon_emoji: ":bell:"
    body = {
      username: username,
      icon_emoji: icon_emoji
    }

    body[:text] = text if text
    body[:blocks] = blocks if blocks

    response = self.class.post(
      @webhook_url,
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )

    raise "Slack notification failed with status #{response.code}: #{response.body}" unless response.success?
  end
end
