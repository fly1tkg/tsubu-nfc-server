class Event < ActiveRecord::Base
  extend Enumerize
  belongs_to :event_set
  serialize :register_users, Array
  enumerize :kind, in: [:study, :drink]

  def self.create_or_update_by_zusaar(zusaar_id, kind, price)
    result = Zusaar.search_users(event_id: zusaar_id)

    return nil unless zusaar_event = result.events[0]

    users_id = []

    # ユーザを作成か更新
    zusaar_event.users.each do |zusaar_user|
      user = User.find_by(zusaar_id: zusaar_user.id) || User.new(zusaar_id: zusaar_user.id)
      user.name = zusaar_user.nickname
      user.save!

      # 参加ユーザのidをpush
      users_id << user.id
    end

    # eventを作成か更新
    event = find_by(zusaar_id: zusaar_id) || new(zusaar_id: zusaar_id)
    event.attributes = {
        register_users: users_id, kind: kind, price: price, title: zusaar_event.title
    }
    event.save!
  end
end
