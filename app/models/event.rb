class Event < ActiveRecord::Base
  extend Enumerize
  belongs_to :event_set
  serialize :register_users, Array
  enumerize :kind, in: [:study, :drink]

  def self.create_or_update_by_zusaar(zusaar_id, kind, price)
    result = Zusaar.search_users(event_id: zusaar_id)

    if zusaar_event = result.events[0]
      users_id = []

      # ユーザを作成か更新
      zusaar_event.users.each do |zusaar_user|
        if user = User.find_by(zusaar_id: zusaar_user.id)
          user.update(name: user.name)
        else
          user = User.create(zusaar_id: zusaar_user.id, name: zusaar_user.nickname)
        end

        # 参加ユーザのidをpush
        users_id << user.id
      end

      # eventを作成か更新
      if event = find_by(zusaar_id: zusaar_id)
        event.update(register_users: users_id, kind: kind, price: price, title: zusaar_event.title)
      else
        create(zusaar_id: zusaar_id, register_users: users_id, kind: kind, price: price, title: zusaar_event.title)
      end
    else
      return nil
    end
  end
end
